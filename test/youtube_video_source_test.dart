import 'package:gabriel_moro_site/data/youtube_video_source.dart';
import 'package:test/test.dart';

void main() {
  test('keeps the newest videos, normalizes thumbnails and skips bad entries', () async {
    final warnings = <String>[];
    final source = YouTubeVideoSource(
      feedUrl: 'https://youtube.test/playlist',
      fetch: (_) async => _playlistXml,
      warn: warnings.add,
      maxVideos: 10,
    );

    final videos = await source.load();

    expect(videos, hasLength(4));
    expect(videos.map((video) => video.title), [
      'Newest video',
      'Without a thumbnail',
      'Insecure thumbnail',
      'Older video',
    ]);
    expect(videos.first.url, 'https://www.youtube.com/watch?v=newest2');
    expect(videos.first.publishedAt, DateTime.utc(2026, 11, 19, 21, 0, 37));
    expect(videos.first.thumbnailUrl, 'https://i2.ytimg.com/vi/newest2/hqdefault.jpg');
    expect(videos[1].thumbnailUrl, 'https://i.ytimg.com/vi/fallback3/hqdefault.jpg');
    expect(videos[2].thumbnailUrl, 'https://i1.ytimg.com/vi/insecure4/hqdefault.jpg');
    expect(warnings, isNotEmpty);
  });

  test('caps the list to maxVideos after sorting by date', () async {
    final source = YouTubeVideoSource(
      feedUrl: 'https://youtube.test/playlist',
      fetch: (_) async => _playlistXml,
      warn: (_) {},
      maxVideos: 2,
    );

    final videos = await source.load();

    expect(videos.map((video) => video.title), ['Newest video', 'Without a thumbnail']);
  });

  test('a failed fetch contributes no videos and reports a warning', () async {
    final warnings = <String>[];
    final source = YouTubeVideoSource(
      fetch: (_) async => throw StateError('offline'),
      warn: warnings.add,
    );

    expect(await source.load(), isEmpty);
    expect(warnings, isNotEmpty);
  });

  test('invalid XML contributes no videos and reports a warning', () async {
    final warnings = <String>[];
    final source = YouTubeVideoSource(
      fetch: (_) async => '<feed>not closed',
      warn: warnings.add,
    );

    expect(await source.load(), isEmpty);
    expect(warnings, isNotEmpty);
  });
}

const _playlistXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:yt="http://www.youtube.com/xml/schemas/2015"
      xmlns:media="http://search.yahoo.com/mrss/">
  <title>Moro no CodandoTV</title>
  <entry>
    <yt:videoId>older1</yt:videoId>
    <title>Older video</title>
    <link rel="alternate" href="https://www.youtube.com/watch?v=older1"/>
    <published>2026-01-10T10:00:00+00:00</published>
    <media:group>
      <media:thumbnail url="https://i1.ytimg.com/vi/older1/hqdefault.jpg"/>
    </media:group>
  </entry>
  <entry>
    <yt:videoId>newest2</yt:videoId>
    <title>Newest video</title>
    <link rel="alternate" href="https://www.youtube.com/watch?v=newest2"/>
    <published>2026-11-19T21:00:37+00:00</published>
    <media:group>
      <media:thumbnail url="https://i2.ytimg.com/vi/newest2/hqdefault.jpg"/>
    </media:group>
  </entry>
  <entry>
    <yt:videoId>duplicate</yt:videoId>
    <title>Duplicate video</title>
    <link rel="alternate" href="https://www.youtube.com/watch?v=newest2"/>
    <published>2026-11-18T21:00:37+00:00</published>
    <media:group>
      <media:thumbnail url="https://i2.ytimg.com/vi/duplicate/hqdefault.jpg"/>
    </media:group>
  </entry>
  <entry>
    <yt:videoId>fallback3</yt:videoId>
    <title>Without a thumbnail</title>
    <link rel="alternate" href="https://www.youtube.com/watch?v=fallback3"/>
    <published>2026-05-01T10:00:00+00:00</published>
    <media:group/>
  </entry>
  <entry>
    <yt:videoId>insecure4</yt:videoId>
    <title>Insecure thumbnail</title>
    <link rel="alternate" href="https://www.youtube.com/watch?v=insecure4"/>
    <published>2026-03-01T10:00:00+00:00</published>
    <media:group>
      <media:thumbnail url="http://i1.ytimg.com/vi/insecure4/hqdefault.jpg"/>
    </media:group>
  </entry>
  <entry>
    <title>Missing link</title>
    <published>2026-06-01T10:00:00+00:00</published>
  </entry>
  <entry>
    <yt:videoId>bad-date</yt:videoId>
    <title>Invalid date</title>
    <link rel="alternate" href="https://www.youtube.com/watch?v=bad-date"/>
    <published>not a date</published>
  </entry>
</feed>
''';
