import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

import 'package:gabriel_moro_site/data/models/youtube_video.dart';

/// Gabriel's curated playlist "Moro no CodandoTV".
///
/// The channel feed mixes every CodandoTV creator, so the site reads the
/// playlist the author curates instead. Update the id, playlist URL and feed
/// URL together if the playlist changes; the JSON assets carry the same
/// playlist URL as `allVideosHref`.
const String moroVideosPlaylistId = 'PLe-UAjk0e26Y';
const String moroVideosPlaylistUrl = 'https://www.youtube.com/playlist?list=$moroVideosPlaylistId';
const String moroVideosFeedUrl = 'https://www.youtube.com/feeds/videos.xml?playlist_id=$moroVideosPlaylistId';

/// Loads the curated playlist feed and keeps the newest videos.
///
/// A feed that cannot be read only logs a warning and contributes no videos,
/// so a transient outage never blocks a build: the repository publishes an
/// empty video list.
final class YouTubeVideoSource {
  YouTubeVideoSource({
    this.feedUrl = moroVideosFeedUrl,
    YouTubeFeedFetcher? fetch,
    YouTubeFeedWarning? warn,
    this.timeout = const Duration(seconds: 15),
    this.maxVideos = 6,
  }) : assert(maxVideos > 0),
       _fetch = fetch ?? _fetchText,
       _warn = warn ?? _defaultWarning;

  final String feedUrl;
  final YouTubeFeedFetcher _fetch;
  final YouTubeFeedWarning _warn;
  final Duration timeout;

  /// Number of newest videos kept by [load].
  final int maxVideos;

  Future<List<YouTubeVideo>> load() async {
    if (Platform.environment['SITE_SKIP_YOUTUBE_FEED'] == '1') {
      _warn('SITE_SKIP_YOUTUBE_FEED=1, skipping the YouTube video fetch.');
      return const [];
    }

    try {
      final source = await _fetch(Uri.parse(feedUrl)).timeout(timeout);
      return _parseFeed(source);
    } catch (error) {
      _warn('Could not load the Moro playlist from $feedUrl: $error');
      return const [];
    }
  }

  List<YouTubeVideo> _parseFeed(String source) {
    final document = XmlDocument.parse(source);
    final videos = <YouTubeVideo>[];
    final seen = <String>{};

    for (final entry in document.findAllElements('entry')) {
      final title = _text(entry, 'title');
      final rawLink = _alternateLink(entry);
      final date = _text(entry, 'published');
      if (title == null || rawLink == null || date == null) {
        _warn('Skipping a video with a missing title, link or date.');
        continue;
      }

      final url = _httpsUrl(rawLink);
      if (url == null) {
        _warn('Skipping a video with an invalid link: $rawLink');
        continue;
      }

      final publishedAt = DateTime.tryParse(date);
      if (publishedAt == null) {
        _warn('Skipping a video with an invalid date: $date');
        continue;
      }

      final videoId = _text(entry, 'videoId') ?? _videoIdFromUrl(url);
      if (videoId == null || videoId.isEmpty) {
        _warn('Skipping a video without a usable id: $url');
        continue;
      }

      final thumbnail = _thumbnail(entry, videoId);

      if (!seen.add(url)) {
        continue;
      }

      videos.add(
        YouTubeVideo(
          videoId: videoId,
          title: title,
          url: url,
          publishedAt: publishedAt,
          thumbnailUrl: thumbnail,
        ),
      );
    }

    videos.sort(_compareVideos);
    return List.unmodifiable(videos.take(maxVideos));
  }
}

int _compareVideos(YouTubeVideo a, YouTubeVideo b) {
  final byDate = b.publishedAt.compareTo(a.publishedAt);
  return byDate != 0 ? byDate : a.title.compareTo(b.title);
}

String? _alternateLink(XmlElement entry) {
  for (final link in entry.findElements('link')) {
    if (link.getAttribute('rel') == 'alternate') {
      final href = link.getAttribute('href')?.trim();
      if (href != null && href.isNotEmpty) {
        return href;
      }
    }
  }

  for (final link in entry.findElements('link')) {
    final href = link.getAttribute('href')?.trim();
    if (href != null && href.isNotEmpty) {
      return href;
    }
  }

  return null;
}

String _thumbnail(XmlElement entry, String videoId) {
  final group = _firstChild(entry, 'group');
  final raw = group == null ? null : _firstChild(group, 'thumbnail')?.getAttribute('url');
  return _httpsUrl(raw) ?? 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg';
}

String? _videoIdFromUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return null;
  }

  final value = uri.queryParameters['v'];
  if (value != null && value.isNotEmpty) {
    return value;
  }

  if (uri.host == 'youtu.be' && uri.pathSegments.isNotEmpty) {
    return uri.pathSegments.first;
  }

  return null;
}

String? _httpsUrl(String? value) {
  if (value == null) {
    return null;
  }

  final uri = Uri.tryParse(value.trim());
  if (uri == null) {
    return null;
  }

  if (uri.isScheme('https')) {
    return uri.toString();
  }
  if (uri.isScheme('http')) {
    return uri.replace(scheme: 'https').toString();
  }

  return null;
}

XmlElement? _firstChild(XmlElement parent, String localName) {
  for (final child in parent.childElements) {
    if (child.name.local == localName) {
      return child;
    }
  }
  return null;
}

String? _text(XmlElement parent, String localName) {
  final element = _firstChild(parent, localName);
  final text = element?.innerText.trim();
  return text == null || text.isEmpty ? null : text;
}

Future<String> _fetchText(Uri uri) async {
  final client = HttpClient()
    ..userAgent = 'gabrielbmoro.dev build (+https://gabrielbmoro.dev)'
    ..connectionTimeout = const Duration(seconds: 10);
  try {
    final request = await client.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/atom+xml, application/xml;q=0.9, */*;q=0.8');
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('Unexpected status ${response.statusCode}', uri: uri);
    }
    // Await the body before returning: `return stream.join()` would run the
    // finally block (and close the client) before the stream finishes.
    final body = await response.transform(utf8.decoder).join();
    return body;
  } finally {
    client.close(force: true);
  }
}

void _defaultWarning(String message) {
  // stdout keeps Jaspr's prerender logger from labelling a fallback as a build
  // error; the build still succeeds.
  stdout.writeln('[videos] $message');
}
