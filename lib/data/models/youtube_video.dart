/// One video fetched from the curated YouTube playlist.
final class YouTubeVideo {
  const YouTubeVideo({
    required this.title,
    required this.url,
    required this.publishedAt,
    required this.thumbnailUrl,
  });

  final String title;

  /// Canonical YouTube watch URL.
  final String url;

  /// Publication instant, in UTC.
  final DateTime publishedAt;

  /// Absolute HTTPS thumbnail URL.
  final String thumbnailUrl;
}

typedef YouTubeFeedFetcher = Future<String> Function(Uri uri);
typedef YouTubeFeedWarning = void Function(String message);
