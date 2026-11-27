import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

import 'package:gabriel_moro_site/data/article_source.dart';

/// A Medium publication whose RSS feed contributes articles.
final class MediumFeed {
  const MediumFeed({required this.source, required this.url});

  /// Publication identity shared with the curated content and the CSS filter.
  final ArticleSource source;

  final String url;

  String get id => source.id;

  /// Publication name rendered by the filter chips.
  String get label => source.label;
}

/// The author whose posts the site publishes.
///
/// Publication feeds include every author, so matching this name is what keeps
/// the articles page personal. Update it if the Medium display name changes.
const String mediumAuthorName = 'Gabriel Bronzatti Moro';

/// The publications surfaced by the articles page.
const List<MediumFeed> mediumFeeds = [
  MediumFeed(
    source: koinDevelopersSource,
    url: 'https://blog.insert-koin.io/feed',
  ),
  MediumFeed(
    source: codandoTvSource,
    url: 'https://medium.com/feed/codandotv',
  ),
];

/// One article fetched from a Medium feed.
final class MediumArticle {
  const MediumArticle({
    required this.title,
    required this.url,
    required this.publishedAt,
    required this.publication,
    required this.sourceId,
    this.imageUrl,
  });

  final String title;

  /// Canonical article URL, without the feed's tracking query.
  final String url;

  /// Publication instant, in UTC.
  final DateTime publishedAt;

  final String publication;

  /// Stable filter key, matching the feed id.
  final String sourceId;

  /// Cover image from the article body, or null when it has none.
  final String? imageUrl;
}

/// Data source for the articles published on Medium.
abstract interface class MediumArticleDataSource {
  Future<List<MediumArticle>> load();
}

typedef MediumFeedFetcher = Future<String> Function(Uri uri);
typedef MediumFeedWarning = void Function(String message);

/// Loads the configured Medium feeds and keeps the author's articles.
///
/// Feeds are fetched concurrently. A feed that cannot be read only logs a
/// warning and contributes no articles, so a transient outage never blocks a
/// build: the repository falls back to the curated articles in the content
/// assets.
final class MediumArticleSource implements MediumArticleDataSource {
  MediumArticleSource({
    List<MediumFeed> feeds = mediumFeeds,
    MediumFeedFetcher? fetch,
    MediumFeedWarning? warn,
    this.timeout = const Duration(seconds: 15),
  }) : _feeds = List.unmodifiable(feeds),
       _fetch = fetch ?? _fetchText,
       _warn = warn ?? _defaultWarning;

  final List<MediumFeed> _feeds;
  final MediumFeedFetcher _fetch;
  final MediumFeedWarning _warn;
  final Duration timeout;

  @override
  Future<List<MediumArticle>> load() async {
    if (Platform.environment['SITE_SKIP_MEDIUM_FEEDS'] == '1') {
      _warn('SITE_SKIP_MEDIUM_FEEDS=1, skipping the Medium article fetch.');
      return const [];
    }

    final results = await Future.wait([for (final feed in _feeds) _loadFeed(feed)]);
    final byUrl = <String, MediumArticle>{};
    for (final articles in results) {
      for (final article in articles) {
        byUrl.putIfAbsent(_canonicalArticleUrl(article.url), () => article);
      }
    }

    final merged = byUrl.values.toList()..sort(_compareArticles);
    return List.unmodifiable(merged);
  }

  Future<List<MediumArticle>> _loadFeed(MediumFeed feed) async {
    try {
      final source = await _fetch(Uri.parse(feed.url)).timeout(timeout);
      return _parseFeed(source, feed);
    } catch (error) {
      _warn('Could not load ${feed.label} from ${feed.url}: $error');
      return const [];
    }
  }

  List<MediumArticle> _parseFeed(String source, MediumFeed feed) {
    final document = XmlDocument.parse(source);
    final channel = _firstElement(document.findAllElements('channel'));
    if (channel == null) {
      throw const FormatException('Missing <channel> element.');
    }

    final articles = <MediumArticle>[];
    final seen = <String>{};

    for (final item in channel.findElements('item')) {
      final creator = _text(item, 'creator');
      if (creator == null || creator.toLowerCase() != mediumAuthorName.toLowerCase()) {
        continue;
      }

      final title = _text(item, 'title');
      final link = _text(item, 'link');
      final date = _text(item, 'pubDate');
      if (title == null || title.isEmpty || link == null || link.isEmpty || date == null || date.isEmpty) {
        _warn('Skipping a ${feed.label} item with a missing title, link or date.');
        continue;
      }

      final uri = Uri.tryParse(link);
      if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
        _warn('Skipping a ${feed.label} item with an invalid link: $link');
        continue;
      }

      final publishedAt = _parseDate(date);
      if (publishedAt == null) {
        _warn('Skipping a ${feed.label} item with an invalid date: $date');
        continue;
      }

      final url = _canonicalArticleUrl(uri.toString());
      if (!seen.add(url)) {
        continue;
      }

      final content = _text(item, 'encoded');
      articles.add(
        MediumArticle(
          title: title,
          url: url,
          publishedAt: publishedAt,
          publication: feed.label,
          sourceId: feed.id,
          imageUrl: content == null ? null : _firstImage(content),
        ),
      );
    }

    return articles;
  }
}

/// The article URL without Medium's `?source=rss-...` tracking query.
String _canonicalArticleUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return url;
  }

  final source = uri.toString();
  final end = source.indexOf(_urlSuffixPattern);
  return end == -1 ? source : source.substring(0, end);
}

int _compareArticles(MediumArticle a, MediumArticle b) {
  final byDate = b.publishedAt.compareTo(a.publishedAt);
  return byDate != 0 ? byDate : a.title.compareTo(b.title);
}

DateTime? _parseDate(String value) {
  try {
    return HttpDate.parse(value);
  } on FormatException {
    return null;
  } on HttpException {
    return null;
  }
}

/// Reads the first usable image from the article HTML.
///
/// Medium wraps the cover in a `<figure>`, but older posts start with another
/// image, so the first non-tracking `<img>` is the best available cover.
String? _firstImage(String content) {
  for (final match in _imagePattern.allMatches(content)) {
    final raw = (match.group(1) ?? match.group(2) ?? '').trim();
    if (raw.isEmpty) {
      continue;
    }

    final uri = Uri.tryParse(raw.replaceAll('&amp;', '&'));
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      continue;
    }
    if (uri.host == 'medium.com' && uri.path.contains('/_/stat')) {
      continue;
    }

    return _mediumImageUrl(uri);
  }
  return null;
}

String _mediumImageUrl(Uri uri) {
  if (uri.host == 'cdn-images-1.medium.com' || uri.host == 'miro.medium.com') {
    final asset = uri.pathSegments.isEmpty ? '' : uri.pathSegments.last;
    if (asset.contains('*')) {
      return 'https://miro.medium.com/v2/resize:fit:480/format:webp/$asset';
    }
  }
  return uri.toString();
}

XmlElement? _firstElement(Iterable<XmlElement> elements) {
  for (final element in elements) {
    return element;
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

final _urlSuffixPattern = RegExp(r'[?#]');

final _imagePattern = RegExp(
  r'''<img\b[^>]*\bsrc\s*=\s*(?:"([^"]*)"|'([^']*)')''',
  caseSensitive: false,
  dotAll: true,
);

Future<String> _fetchText(Uri uri) async {
  final client = HttpClient()
    ..userAgent = 'gabrielbmoro.dev build (+https://gabrielbmoro.dev)'
    ..connectionTimeout = const Duration(seconds: 10);
  try {
    final request = await client.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/rss+xml, application/xml;q=0.9, */*;q=0.8');
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
  stdout.writeln('[articles] $message');
}
