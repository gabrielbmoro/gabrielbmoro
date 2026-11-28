import 'package:gabriel_moro_site/data/medium_article_source.dart';
import 'package:gabriel_moro_site/data/models/article_source.dart';
import 'package:gabriel_moro_site/data/models/medium_article.dart';
import 'package:test/test.dart';

const _feed = MediumFeed(
  source: koinDevelopersSource,
  url: 'https://blog.insert-koin.io/feed',
);

void main() {
  test('keeps only the configured author and normalizes the feed item', () async {
    final source = MediumArticleSource(
      feeds: [_feed],
      fetch: (_) async => _feedXml,
      warn: (_) {},
    );

    final articles = await source.load();

    expect(articles, hasLength(2));
    expect(articles.first.title, 'Keeping the build green');
    expect(
      articles.first.url,
      'https://blog.insert-koin.io/keeping-the-build-green-abc123',
    );
    expect(articles.first.publishedAt, DateTime.utc(2026, 11, 16, 13, 1, 4));
    expect(articles.first.publication, 'Koin Developers');
    expect(articles.first.sourceId, 'koin-developers');
    expect(
      articles.first.imageUrl,
      'https://miro.medium.com/v2/resize:fit:480/format:webp/1*abc.png',
    );
    expect(articles.last.imageUrl, isNull);
  });

  test('a broken feed does not discard the other feed', () async {
    final warnings = <String>[];
    final source = MediumArticleSource(
      feeds: [
        _feed,
        const MediumFeed(
          source: codandoTvSource,
          url: 'https://medium.com/feed/codandotv',
        ),
      ],
      fetch: (uri) async {
        if (uri.host == 'blog.insert-koin.io') {
          throw StateError('offline');
        }
        return _otherFeedXml;
      },
      warn: warnings.add,
    );

    final articles = await source.load();

    expect(articles, hasLength(1));
    expect(articles.single.publication, 'CodandoTV');
    expect(warnings, isNotEmpty);
  });

  test('the author feed recovers an article the publication feed no longer lists', () async {
    final warnings = <String>[];
    final source = MediumArticleSource(
      feeds: const [
        MediumFeed(
          source: codandoTvSource,
          url: 'https://medium.com/feed/codandotv',
        ),
        MediumFeed.author(url: 'https://medium.com/feed/@author'),
      ],
      fetch: (uri) async => uri.path.startsWith('/feed/@') ? _authorFeedXml : _windowedCodandoFeedXml,
      warn: warnings.add,
    );

    final articles = await source.load();

    expect(
      articles.map((article) => article.title),
      [
        'Still in the window',
        'A Koin post only in the profile feed',
        'Squeezed out of the publication feed',
      ],
    );
    final recovered = articles.firstWhere(
      (article) => article.title == 'Squeezed out of the publication feed',
    );
    expect(recovered.publication, 'CodandoTV');
    expect(recovered.sourceId, 'codandotv');
    expect(
      articles
          .firstWhere(
            (article) => article.title == 'A Koin post only in the profile feed',
          )
          .sourceId,
      'koin-developers',
    );
    expect(warnings.single, contains('unknown publication'));
  });

  test('invalid XML is reported and contributes no articles', () async {
    final warnings = <String>[];
    final source = MediumArticleSource(
      feeds: [_feed],
      fetch: (_) async => '<rss>not closed',
      warn: warnings.add,
    );

    expect(await source.load(), isEmpty);
    expect(warnings, isNotEmpty);
  });
}

const _feedXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     version="2.0">
  <channel>
    <title>Koin Developers - Medium</title>
    <item>
      <title><![CDATA[Keeping the build green]]></title>
      <link>https://blog.insert-koin.io/keeping-the-build-green-abc123?source=rss----1---4</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Mon, 16 Nov 2026 13:01:04 GMT</pubDate>
      <content:encoded><![CDATA[
        <img src="https://medium.com/_/stat?event=x" />
        <figure><img src="https://cdn-images-1.medium.com/max/1024/1*abc.png" /></figure>
        <p>Body</p>
      ]]></content:encoded>
    </item>
    <item>
      <title><![CDATA[Someone else's article]]></title>
      <link>https://blog.insert-koin.io/someone-else-def456</link>
      <dc:creator><![CDATA[Arnaud Giuliani]]></dc:creator>
      <pubDate>Tue, 10 Nov 2026 09:00:00 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
    <item>
      <title><![CDATA[Without a cover]]></title>
      <link>https://blog.insert-koin.io/without-a-cover-ghi789</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Fri, 24 Apr 2026 07:18:23 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
  </channel>
</rss>
''';

const _otherFeedXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     version="2.0">
  <channel>
    <title>CodandoTV - Medium</title>
    <item>
      <title><![CDATA[A CodandoTV post]]></title>
      <link>https://medium.com/codandotv/a-post-xyz</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Thu, 30 Jul 2026 12:00:00 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
  </channel>
</rss>
''';

const _windowedCodandoFeedXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     version="2.0">
  <channel>
    <title>CodandoTV - Medium</title>
    <item>
      <title><![CDATA[Still in the window]]></title>
      <link>https://medium.com/codandotv/still-in-the-window-abc123</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Thu, 30 Jul 2026 12:00:00 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
    <item>
      <title><![CDATA[Another CodandoTV author]]></title>
      <link>https://medium.com/codandotv/another-author-def456</link>
      <dc:creator><![CDATA[Pedro Alvarez]]></dc:creator>
      <pubDate>Tue, 04 Aug 2026 12:00:00 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
  </channel>
</rss>
''';

const _authorFeedXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     version="2.0">
  <channel>
    <title>Stories by Gabriel Bronzatti Moro - Medium</title>
    <item>
      <title><![CDATA[Still in the window]]></title>
      <link>https://medium.com/codandotv/still-in-the-window-abc123?source=rss-1------2</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Thu, 30 Jul 2026 12:00:00 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
    <item>
      <title><![CDATA[A Koin post only in the profile feed]]></title>
      <link>https://blog.insert-koin.io/koin-post-jkl012?source=rss-3------2</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Mon, 01 Jun 2026 12:00:00 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
    <item>
      <title><![CDATA[Squeezed out of the publication feed]]></title>
      <link>https://medium.com/codandotv/squeezed-out-ghi789?source=rss-1------2</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Fri, 08 May 2026 02:06:54 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
    <item>
      <title><![CDATA[Somewhere else]]></title>
      <link>https://example.com/somewhere-else</link>
      <dc:creator><![CDATA[Gabriel Bronzatti Moro]]></dc:creator>
      <pubDate>Mon, 04 May 2026 12:00:00 GMT</pubDate>
      <content:encoded><![CDATA[<p>Body</p>]]></content:encoded>
    </item>
  </channel>
</rss>
''';
