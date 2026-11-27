import 'package:gabriel_moro_site/data/models/article_source.dart';

/// A Medium publication whose RSS feed contributes articles.
final class MediumFeed {
  const MediumFeed({required this.source, required this.url});

  /// Publication identity shared with the CSS filter.
  final ArticleSource source;

  final String url;

  String get id => source.id;

  /// Publication name rendered by the filter chips.
  String get label => source.label;
}

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

typedef MediumFeedFetcher = Future<String> Function(Uri uri);
typedef MediumFeedWarning = void Function(String message);
