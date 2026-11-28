import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:gabriel_moro_site/data/medium_article_source.dart';
import 'package:gabriel_moro_site/data/models/article_source.dart';
import 'package:gabriel_moro_site/data/models/medium_article.dart';
import 'package:gabriel_moro_site/data/repository_impl.dart';
import 'package:gabriel_moro_site/data/youtube_video_source.dart';
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

YouTubeVideoSource _videoSource() => YouTubeVideoSource(
  feedUrl: 'https://youtube.test/playlist',
  fetch: (_) async => _playlistFeedXml,
  warn: (_) {},
);

void main() {
  test('publishes the Medium articles and YouTube videos, newest first, with localized dates', () async {
    final repository = await SiteContentRepositoryImpl.load(
      content: JsonSiteContentDataSource(),
      mediumArticles: _mediumSource(),
      youTubeVideos: _videoSource(),
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

    expect(en.contentHub.videos, hasLength(2));
    expect(pt.contentHub.videos, hasLength(2));
    expect(en.contentHub.videos.first.title, 'A newer Koin video');
    expect(en.contentHub.videos.first.published, 'Nov 2026');
    expect(
      en.contentHub.videos.first.thumbnail,
      'https://i1.ytimg.com/vi/newer-video/hqdefault.jpg',
    );
    expect(pt.contentHub.videos.first.published, 'Nov 2026');
    expect(en.contentHub.videos.last.title, 'An older Koin video');
    expect(en.contentHub.videos.last.published, 'Jul 2026');

    final contentPage = repository.pages.firstWhere(
      (page) => page.id == PageId.content && page.content.lang == 'en',
    );
    expect(contentPage.content.contentHub.articles, hasLength(2));
    expect(contentPage.content.contentHub.articles.first.title, 'A newer Koin article');
    expect(contentPage.content.contentHub.videos, hasLength(2));
    expect(contentPage.content.contentHub.videos.first.title, 'A newer Koin video');
  });

  test('publishes empty feed lists when the data sources are empty', () async {
    final repository = await SiteContentRepositoryImpl.load(
      content: JsonSiteContentDataSource(),
      mediumArticles: MediumArticleSource(feeds: const []),
      youTubeVideos: YouTubeVideoSource(
        feedUrl: 'https://youtube.test/playlist',
        fetch: (_) async => _emptyPlaylistFeed,
        warn: (_) {},
      ),
    );

    final en = repository.contentFor('en');
    final pt = repository.contentFor('pt-BR');

    expect(en.contentHub.articles, isEmpty);
    expect(pt.contentHub.articles, isEmpty);
    expect(en.contentHub.videos, isEmpty);
    expect(pt.contentHub.videos, isEmpty);

    final contentPage = repository.pages.firstWhere(
      (page) => page.id == PageId.content && page.content.lang == 'en',
    );
    expect(contentPage.content.contentHub.articles, isEmpty);
    expect(contentPage.content.contentHub.videos, isEmpty);
  });

  test('a broken video feed keeps the articles', () async {
    final repository = await SiteContentRepositoryImpl.load(
      content: JsonSiteContentDataSource(),
      mediumArticles: _mediumSource(),
      youTubeVideos: YouTubeVideoSource(
        feedUrl: 'https://youtube.test/playlist',
        fetch: (_) async => throw StateError('offline'),
        warn: (_) {},
      ),
    );

    final en = repository.contentFor('en');

    expect(en.contentHub.articles, hasLength(2));
    expect(en.contentHub.videos, isEmpty);
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

const _playlistFeedXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:yt="http://www.youtube.com/xml/schemas/2015"
      xmlns:media="http://search.yahoo.com/mrss/">
  <title>Moro no CodandoTV</title>
  <entry>
    <yt:videoId>older-video</yt:videoId>
    <title>An older Koin video</title>
    <link rel="alternate" href="https://www.youtube.com/watch?v=older-video"/>
    <published>2026-07-30T12:00:00+00:00</published>
    <media:group>
      <media:thumbnail url="https://i2.ytimg.com/vi/older-video/hqdefault.jpg"/>
    </media:group>
  </entry>
  <entry>
    <yt:videoId>newer-video</yt:videoId>
    <title>A newer Koin video</title>
    <link rel="alternate" href="https://www.youtube.com/watch?v=newer-video"/>
    <published>2026-11-19T21:00:37+00:00</published>
    <media:group>
      <media:thumbnail url="https://i1.ytimg.com/vi/newer-video/hqdefault.jpg"/>
    </media:group>
  </entry>
</feed>
''';

const _emptyPlaylistFeed = '''
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Moro no CodandoTV</title>
</feed>
''';
