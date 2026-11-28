import 'dart:io';

import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:gabriel_moro_site/data/medium_article_source.dart';
import 'package:gabriel_moro_site/data/models/medium_article.dart';
import 'package:gabriel_moro_site/data/models/youtube_video.dart';
import 'package:gabriel_moro_site/data/youtube_video_source.dart';
import 'package:gabriel_moro_site/domain/models/site_catalog.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/domain/repository.dart';

/// Content repository composed from the localized JSON content, the Medium
/// articles and the curated YouTube playlist.
///
/// The three data sources are independent: this repository loads the feeds in
/// parallel, attaches the articles and videos to each locale's content, and
/// rebuilds the pages so their content points at the composed catalog. The JSON
/// assets only own the section copy; feed items come from their data sources.
final class SiteContentRepositoryImpl implements SiteContentRepository {
  SiteContentRepositoryImpl._(this._catalog);

  final SiteCatalog _catalog;

  /// Loads the data sources and returns a repository backed by the composed
  /// catalog. The article and video lists are empty when their data sources
  /// have nothing to publish.
  static Future<SiteContentRepositoryImpl> load({
    required JsonSiteContentDataSource content,
    required MediumArticleSource mediumArticles,
    required YouTubeVideoSource youTubeVideos,
  }) async {
    final catalog = content.load();

    final articlesFuture = _loadArticles(mediumArticles);
    final videosFuture = _loadVideos(youTubeVideos);
    final articles = await articlesFuture;
    final videos = await videosFuture;

    final sortedArticles = [...articles]..sort(_compareArticles);
    final sortedVideos = [...videos]..sort(_compareVideos);
    return SiteContentRepositoryImpl._(_composeCatalog(catalog, sortedArticles, sortedVideos));
  }

  @override
  List<SiteContent> get contents => _catalog.contents;

  @override
  List<SitePage> get pages => _catalog.pages;

  @override
  SiteContent get defaultContent => _catalog.contents.first;

  @override
  SitePage get defaultPage => _catalog.pages.first;

  @override
  SiteContent contentFor(String lang) => _catalog.contents.firstWhere(
    (content) => content.lang == lang,
    orElse: () => throw ArgumentError.value(lang, 'lang', 'Unknown site locale'),
  );

  static Future<List<MediumArticle>> _loadArticles(MediumArticleSource source) async {
    try {
      return await source.load();
    } catch (error) {
      stdout.writeln('[articles] Could not load Medium articles: $error');
      return const [];
    }
  }

  static Future<List<YouTubeVideo>> _loadVideos(YouTubeVideoSource source) async {
    try {
      return await source.load();
    } catch (error) {
      stdout.writeln('[videos] Could not load YouTube videos: $error');
      return const [];
    }
  }

  static SiteCatalog _composeCatalog(
    SiteCatalog catalog,
    List<MediumArticle> articles,
    List<YouTubeVideo> videos,
  ) {
    final contents = <SiteContent>[];
    for (final content in catalog.contents) {
      final hub = content.contentHub;
      contents.add(
        content.withContentHub(
          hub.withContent(
            articles: _articlesForLocale(articles, hub.articleMonths),
            videos: _videosForLocale(videos, hub.articleMonths),
          ),
        ),
      );
    }

    final byLang = {for (final content in contents) content.lang: content};
    final pages = [
      for (final page in catalog.pages) page.withContent(byLang[page.content.lang]!),
    ];

    return SiteCatalog(
      contents: List.unmodifiable(contents),
      pages: List.unmodifiable(pages),
    );
  }

  static List<Article> _articlesForLocale(List<MediumArticle> articles, List<String> months) => [
    for (final article in articles)
      Article(
        title: article.title,
        publication: article.publication,
        sourceId: article.sourceId,
        published: _formatDate(article.publishedAt, months),
        url: article.url,
        thumbnail: article.imageUrl,
      ),
  ];

  static List<Video> _videosForLocale(List<YouTubeVideo> videos, List<String> months) => [
    for (final video in videos)
      Video(
        title: video.title,
        published: _formatDate(video.publishedAt, months),
        url: video.url,
        thumbnail: video.thumbnailUrl,
        embedUrl: 'https://www.youtube-nocookie.com/embed/${video.videoId}',
      ),
  ];

  static int _compareArticles(MediumArticle a, MediumArticle b) {
    final byDate = b.publishedAt.compareTo(a.publishedAt);
    return byDate != 0 ? byDate : a.title.compareTo(b.title);
  }

  static int _compareVideos(YouTubeVideo a, YouTubeVideo b) {
    final byDate = b.publishedAt.compareTo(a.publishedAt);
    return byDate != 0 ? byDate : a.title.compareTo(b.title);
  }

  static String _formatDate(DateTime date, List<String> months) => '${months[date.month - 1]} ${date.year}';
}
