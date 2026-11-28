import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:gabriel_moro_site/data/youtube_video_source.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:test/test.dart';

void main() {
  test('loads the content copy and leaves the feed lists to the repository', () {
    final catalog = JsonSiteContentDataSource().load();

    expect(catalog.contents, hasLength(2));
    for (final content in catalog.contents) {
      expect(content.contentHub.articleMonths, hasLength(12));
      expect(content.contentHub.articles, isEmpty);
      expect(content.contentHub.videos, isEmpty);
      expect(content.contentHub.filterAllLabel, isNotEmpty);
      expect(content.contentHub.filterAriaLabel, isNotEmpty);
      expect(content.contentHub.contentFilterAriaLabel, isNotEmpty);
      expect(content.contentHub.filterArticlesLabel, isNotEmpty);
      expect(content.contentHub.filterVideosLabel, isNotEmpty);
      expect(content.contentHub.videosTitle, isNotEmpty);
      expect(content.contentHub.allVideosLabel, isNotEmpty);
      expect(content.contentHub.allVideosHref, moroVideosPlaylistUrl);
    }

    final contentPages = {
      for (final page in catalog.pages)
        if (page.id == PageId.content) page.content.lang: page.route,
    };
    expect(contentPages['pt-BR'], '/conteudo');
    expect(contentPages['en'], '/en/content');
  });

  test('the content hub also-sharing block lists only talks', () {
    final catalog = JsonSiteContentDataSource().load();
    final channelsByLang = {
      for (final content in catalog.contents) content.lang: content.contentHub.channels,
    };

    expect(channelsByLang['pt-BR']!.map((channel) => channel.label), ['Palestras']);
    expect(channelsByLang['en']!.map((channel) => channel.label), ['Talks']);

    for (final channel in channelsByLang.values.expand((channels) => channels)) {
      expect(channel.description, contains('GDG'));
      expect(channel.description, contains('DevFest'));
      expect(channel.links, hasLength(1));
      expect(
        channel.links.single.url,
        'https://www.linkedin.com/in/gabrielbronzattimoro15031994/',
      );
    }
  });
}
