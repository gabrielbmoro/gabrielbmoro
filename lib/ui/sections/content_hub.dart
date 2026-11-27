import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/ui/components/action_link.dart';
import 'package:gabriel_moro_site/ui/components/section_heading.dart';
import 'package:gabriel_moro_site/ui/components/text_link.dart';

/// The articles hub: the latest posts, where else to follow along, and the
/// topics covered.
class ContentHubSection extends StatelessComponent {
  const ContentHubSection({required this.page, super.key});

  final SitePage page;

  Component _articleLink(Article article) {
    final thumbnail = article.thumbnail;

    return a(
      href: article.url,
      classes: 'article-link',
      target: Target.blank,
      attributes: const {'rel': 'noopener noreferrer'},
      [
        if (thumbnail != null)
          span(
            classes: 'article-thumb',
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
        span(classes: 'article-body', [
          span(classes: 'article-meta', [.text('${article.publication} · ${article.published}')]),
          span(classes: 'article-title', [.text(article.title)]),
        ]),
      ],
    );
  }

  /// Publication filters in first-seen order, so the chips follow the newest
  /// article's publication.
  List<({String id, String label})> _articleSources(ContentHub hub) {
    final sources = <String, String>{};
    for (final article in hub.articles) {
      sources.putIfAbsent(article.sourceId, () => article.publication);
    }
    return [for (final entry in sources.entries) (id: entry.key, label: entry.value)];
  }

  Component _articleFilter(ContentHub hub, List<({String id, String label})> sources) {
    return fieldset(classes: 'article-filter', [
      legend(classes: 'visually-hidden', [.text(hub.filterAriaLabel)]),
      _filterOption(id: 'article-filter-all', value: 'all', chipLabel: hub.filterAllLabel, checked: true),
      for (final source in sources)
        _filterOption(id: 'article-filter-${source.id}', value: source.id, chipLabel: source.label),
    ]);
  }

  Component _filterOption({
    required String id,
    required String value,
    required String chipLabel,
    bool checked = false,
  }) {
    return Component.fragment([
      input(
        type: InputType.radio,
        id: id,
        name: 'article-source',
        value: value,
        checked: checked,
        classes: 'article-filter-input',
      ),
      label([.text(chipLabel)], htmlFor: id, classes: 'article-filter-chip'),
    ]);
  }

  @override
  Component build(BuildContext context) {
    final content = page.content;
    final hub = content.contentHub;
    final recognition = hub.recognition;
    final sources = _articleSources(hub);

    return section(classes: 'section section--tint', id: 'articles', [
      div(classes: 'container', [
        SectionHeading(eyebrow: hub.eyebrow, title: hub.heading, lede: hub.lede),
        div(classes: 'articles-block', [
          h3([.text(hub.latestTitle)]),
          if (sources.length > 1) _articleFilter(hub, sources),
          ol(classes: 'article-list', [
            for (final article in hub.articles)
              li(
                classes: 'article-item',
                attributes: {'data-source': article.sourceId},
                [_articleLink(article)],
              ),
          ]),
          div(classes: 'articles-all', [
            TextLink(hub.allArticlesLabel, href: hub.allArticlesHref),
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
