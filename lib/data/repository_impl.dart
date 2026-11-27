import 'dart:io';

import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:gabriel_moro_site/data/medium_article_source.dart';
import 'package:gabriel_moro_site/data/models/medium_article.dart';
import 'package:gabriel_moro_site/domain/models/site_catalog.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/domain/repository.dart';

/// Content repository composed from the localized JSON content and the Medium
/// articles.
///
/// The two data sources are independent: this repository loads both, attaches
/// the Medium articles to each locale's content, and rebuilds the pages so
/// their content points at the composed catalog. The JSON assets only own the
/// section copy; articles come exclusively from Medium.
final class SiteContentRepositoryImpl implements SiteContentRepository {
  SiteContentRepositoryImpl._(this._catalog);

  final SiteCatalog _catalog;

  /// Loads both data sources and returns a repository backed by the composed
  /// catalog. The article list is empty when the Medium data source has
  /// nothing to publish.
  static Future<SiteContentRepositoryImpl> load({
    required JsonSiteContentDataSource content,
    required MediumArticleSource mediumArticles,
  }) async {
    final catalog = content.load();

    List<MediumArticle> articles;
    try {
      articles = await mediumArticles.load();
    } catch (error) {
      stdout.writeln('[articles] Could not load Medium articles: $error');
      articles = const [];
    }

    final sorted = [...articles]..sort(_compareArticles);
    return SiteContentRepositoryImpl._(_composeCatalog(catalog, sorted));
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
}

SiteCatalog _composeCatalog(SiteCatalog catalog, List<MediumArticle> articles) {
  final contents = <SiteContent>[];
  for (final content in catalog.contents) {
    final hub = content.contentHub;
    contents.add(content.withContentHub(hub.withArticles(_articlesForLocale(articles, hub.articleMonths))));
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

List<Article> _articlesForLocale(List<MediumArticle> articles, List<String> months) => [
  for (final article in articles)
    Article(
      title: article.title,
      publication: article.publication,
      sourceId: article.sourceId,
      published: _formatArticleDate(article.publishedAt, months),
      url: article.url,
      thumbnail: article.imageUrl,
    ),
];

int _compareArticles(MediumArticle a, MediumArticle b) {
  final byDate = b.publishedAt.compareTo(a.publishedAt);
  return byDate != 0 ? byDate : a.title.compareTo(b.title);
}

String _formatArticleDate(DateTime date, List<String> months) => '${months[date.month - 1]} ${date.year}';
