import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:gabriel_moro_site/data/medium_article_source.dart';
import 'package:gabriel_moro_site/data/repository_impl.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:test/test.dart';

final class _FakeMediumArticles implements MediumArticleDataSource {
  const _FakeMediumArticles(this.articles);

  final List<MediumArticle> articles;

  @override
  Future<List<MediumArticle>> load() async => articles;
}

void main() {
  test('publishes only the Medium articles, newest first, with localized dates', () async {
    final repository = await SiteContentRepositoryImpl.load(
      content: JsonSiteContentDataSource(),
      mediumArticles: _FakeMediumArticles([
        MediumArticle(
          title: 'A CodandoTV article',
          url: 'https://medium.com/codandotv/a-codandotv-article-xyz',
          publishedAt: DateTime.utc(2026, 7, 30, 12),
          publication: 'CodandoTV',
          sourceId: 'codandotv',
        ),
        MediumArticle(
          title: 'A newer Koin article',
          url: 'https://blog.insert-koin.io/a-newer-koin-article-abc123',
          publishedAt: DateTime.utc(2026, 11, 16, 13),
          publication: 'Koin Developers',
          sourceId: 'koin-developers',
          imageUrl: 'https://miro.medium.com/v2/resize:fit:480/format:webp/1*cover.png',
        ),
      ]),
    );

    final en = repository.contentFor('en');
    final pt = repository.contentFor('pt-BR');

    expect(repository.contents, hasLength(2));
    expect(en.contentHub.articles, hasLength(2));
    expect(pt.contentHub.articles, hasLength(2));
    expect(en.contentHub.articles.first.title, 'A newer Koin article');
    expect(en.contentHub.articles.first.published, 'Nov 2026');
    expect(en.contentHub.articles.first.thumbnail, 'https://miro.medium.com/v2/resize:fit:480/format:webp/1*cover.png');
    expect(pt.contentHub.articles.first.published, 'Nov 2026');
    expect(en.contentHub.articles.last.title, 'A CodandoTV article');
    expect(en.contentHub.articles.last.published, 'Jul 2026');
    expect(
      en.contentHub.articles.map((article) => article.sourceId).toSet(),
      {'koin-developers', 'codandotv'},
    );

    final articlesPage = repository.pages.firstWhere(
      (page) => page.id == PageId.articles && page.content.lang == 'en',
    );
    expect(articlesPage.content.contentHub.articles, hasLength(2));
    expect(articlesPage.content.contentHub.articles.first.title, 'A newer Koin article');
  });

  test('publishes no articles when the Medium data source is empty', () async {
    final repository = await SiteContentRepositoryImpl.load(
      content: JsonSiteContentDataSource(),
      mediumArticles: const _FakeMediumArticles([]),
    );

    final en = repository.contentFor('en');
    final pt = repository.contentFor('pt-BR');

    expect(en.contentHub.articles, isEmpty);
    expect(pt.contentHub.articles, isEmpty);

    final articlesPage = repository.pages.firstWhere(
      (page) => page.id == PageId.articles && page.content.lang == 'en',
    );
    expect(articlesPage.content.contentHub.articles, isEmpty);
  });
}
