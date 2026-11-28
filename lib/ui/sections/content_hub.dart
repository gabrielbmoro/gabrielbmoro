import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/ui/components/action_link.dart';
import 'package:gabriel_moro_site/ui/components/section_heading.dart';
import 'package:gabriel_moro_site/ui/components/text_link.dart';

/// The content hub: the latest articles, the latest videos, where else to
/// follow along, and the topics covered.
class ContentHubSection extends StatelessComponent {
  const ContentHubSection({required this.page, super.key});

  final SitePage page;

  Component _articleLink(Article article) {
    final thumbnail = article.thumbnail;

    return a(
      href: article.url,
      classes: 'content-link',
      target: Target.blank,
      attributes: const {'rel': 'noopener noreferrer'},
      [
        if (thumbnail != null)
          span(
            classes: 'content-thumb',
            attributes: const {'aria-hidden': 'true'},
            [
              img(
                src: thumbnail,
                alt: '',
                width: 480,
                height: 270,
                loading: MediaLoading.lazy,
                attributes: const {'decoding': 'async'},
              ),
            ],
          ),
        span(classes: 'content-body', [
          span(classes: 'content-meta', [.text('${article.publication} · ${article.published}')]),
          span(classes: 'content-title', [.text(article.title)]),
        ]),
      ],
    );
  }

  Component _videoCard(Video video) {
    return li(classes: 'content-item', [
      div(classes: 'video-player', [
        img(
          src: video.thumbnail,
          alt: '',
          width: 480,
          height: 360,
          classes: 'video-poster',
          loading: MediaLoading.lazy,
          attributes: const {'decoding': 'async', 'aria-hidden': 'true'},
        ),
        iframe(
          const [],
          src: video.embedUrl,
          width: 480,
          height: 270,
          classes: 'video-frame',
          loading: MediaLoading.lazy,
          allow: 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share',
          attributes: {'title': video.title, 'allowfullscreen': ''},
        ),
      ]),
      div(classes: 'content-body', [
        span(classes: 'content-meta', [.text(video.published)]),
        a(
          href: video.url,
          classes: 'content-title video-title-link',
          target: Target.blank,
          attributes: const {'rel': 'noopener noreferrer'},
          [.text(video.title)],
        ),
      ]),
    ]);
  }

  /// One horizontally scrolling carousel per publication.
  Component _articleCarousel(ArticleGroup group) {
    final headingId = 'article-carousel-${group.sourceId}';
    return div(classes: 'article-carousel', [
      h4(id: headingId, [.text(group.label)]),
      ol(
        classes: 'content-carousel',
        attributes: {'aria-labelledby': headingId},
        [
          for (final article in group.articles) li(classes: 'content-item', [_articleLink(article)]),
        ],
      ),
    ]);
  }

  Component _contentTypeFilter(ContentHub hub) {
    return fieldset(classes: 'filter-bar content-type-filter', [
      legend(classes: 'visually-hidden', [.text(hub.contentFilterAriaLabel)]),
      _filterOption(
        id: 'content-type-articles',
        name: 'content-type',
        value: 'articles',
        chipLabel: hub.filterArticlesLabel,
        inputClass: 'content-type-input',
        checked: true,
      ),
      _filterOption(
        id: 'content-type-videos',
        name: 'content-type',
        value: 'videos',
        chipLabel: hub.filterVideosLabel,
        inputClass: 'content-type-input',
      ),
    ]);
  }

  Component _filterOption({
    required String id,
    required String name,
    required String value,
    required String chipLabel,
    required String inputClass,
    bool checked = false,
  }) {
    return Component.fragment([
      input(
        type: InputType.radio,
        id: id,
        name: name,
        value: value,
        checked: checked,
        classes: 'filter-input $inputClass',
      ),
      label([.text(chipLabel)], htmlFor: id, classes: 'filter-chip'),
    ]);
  }

  @override
  Component build(BuildContext context) {
    final content = page.content;
    final hub = content.contentHub;
    final recognition = hub.recognition;
    final hasArticles = hub.articles.isNotEmpty;
    final hasVideos = hub.videos.isNotEmpty;
    final showTypeFilter = hasArticles && hasVideos;
    final showArticles = hasArticles || !hasVideos;

    return section(classes: 'section section--tint', id: 'content', [
      div(classes: 'container', [
        SectionHeading(eyebrow: hub.eyebrow, title: hub.heading, lede: hub.lede),
        div(classes: 'content-hub', [
          if (showTypeFilter) _contentTypeFilter(hub),
          if (showArticles)
            div(classes: 'articles-block', [
              h3([.text(hub.latestTitle)]),
              for (final group in hub.articleGroups) _articleCarousel(group),
              div(classes: 'content-all', [
                TextLink(hub.allArticlesLabel, href: hub.allArticlesHref),
              ]),
            ]),
          if (hasVideos)
            div(classes: 'videos-block', [
              h3([.text(hub.videosTitle)]),
              ol(classes: 'video-grid', [
                for (final video in hub.videos) _videoCard(video),
              ]),
              div(classes: 'content-all', [
                TextLink(hub.allVideosLabel, href: hub.allVideosHref),
              ]),
            ]),
        ]),
        div(classes: 'channels-block', [
          h3([.text(hub.channelsTitle)]),
          div(classes: 'channel-grid', [
            for (final channel in hub.channels)
              article(classes: 'channel-card', [
                h3([.text(channel.label)]),
                p(classes: 'channel-description', [.text(channel.description)]),
                if (channel.links.isNotEmpty)
                  div(classes: 'channel-links', [
                    for (final link in channel.links) TextLink(link.label, href: link.url),
                  ]),
              ]),
          ]),
        ]),
        div(classes: 'topics-block', [
          h3([.text(hub.topicsTitle)]),
          ul(classes: 'topics', [
            for (final topic in hub.topics) li(classes: 'topic', [.text(topic)]),
          ]),
        ]),
        div(classes: 'recognition', [
          p(classes: 'recognition-label', [.text(recognition.label)]),
          p(classes: 'recognition-text', [.text(recognition.description)]),
          TextLink(recognition.linkLabel, href: recognition.url),
        ]),
        div(classes: 'cta-band', [
          div(classes: 'cta-copy', [
            p(classes: 'cta-title', [.text(hub.ctaTitle)]),
            p(classes: 'cta-text', [.text(hub.ctaText)]),
          ]),
          ActionLink(href: hub.ctaHref, label: hub.ctaButton, icon: ActionIcon.upRight, external: true),
        ]),
      ]),
    ]);
  }
}
