import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:gabriel_moro_site/data/medium_article_source.dart';
import 'package:gabriel_moro_site/data/models/article_source.dart';
import 'package:gabriel_moro_site/data/models/medium_article.dart';
import 'package:gabriel_moro_site/data/repository_impl.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:test/test.dart';

MediumArticleSource _mediumSource() => MediumArticleSource(
  feeds: const [
    MediumFeed(source: koinDevelopersSource, url: 'https://koin.test/feed'),
    MediumFeed(source: codandoTvSource, url: 'https://codando.test/feed'),
  ],
  fetch: (uri) async => uri.host == 'koin.test' ? _koinFeedXml : _codandoFeedXml,
  warn: (_) {},
);

void main() {
  test('publishes only the Medium articles, newest first, with localized dates', () async {
    final repository = await SiteContentRepositoryImpl.load(
      content: JsonSiteContentDataSource(),
      mediumArticles: _mediumSource(),
    );

    final en = repository.contentFor('en');
    final pt = repository.contentFor('pt-BR');

    expect(repository.contents, hasLength(2));
    expect(en.contentHub.articles, hasLength(2));
    expect(pt.contentHub.articles, hasLength(2));
    expect(en.contentHub.articles.first.title, 'A newer Koin article');
    expect(en.contentHub.articles.first.published, 'Nov 2026');
    expect(
      en.contentHub.articles.first.thumbnail,
      'https://miro.medium.com/v2/resize:fit:480/format:webp/1*cover.png',
    );
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
      mediumArticles: MediumArticleSource(feeds: const []),
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

const _koinFeedXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     version="2.0">
  <channel>
    <title>Koin Developers - Medium</title>
    <item>
      <title><![CDATA[A newer Koin article]]></title>
      <link>https://blog.insert-koin.io/a-newer-koin-article-abc123?source=rss----1---4</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Mon, 16 Nov 2026 13:01:04 GMT</pubDate>
      <content:encoded><![CDATA[
        <figure><img src="https://cdn-images-1.medium.com/max/1024/1*cover.png" /></figure>
      ]]></content:encoded>
    </item>
  </channel>
</rss>
''';

const _codandoFeedXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     version="2.0">
  <channel>
    <title>CodandoTV - Medium</title>
    <item>
      <title><![CDATA[A CodandoTV article]]></title>
      <link>https://medium.com/codandotv/a-codandotv-article-xyz</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Thu, 30 Jul 2026 12:00:00 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
  </channel>
</rss>
''';
