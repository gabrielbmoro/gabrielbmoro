import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/ui/components/action_link.dart';
import 'package:gabriel_moro_site/ui/components/section_heading.dart';
import 'package:gabriel_moro_site/ui/components/text_link.dart';

/// The articles hub: the latest posts, where else to follow along, and the
/// topics covered.
class ContentHubSection extends StatelessComponent {
  const ContentHubSection({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    final hub = content.contentHub;
    final recognition = hub.recognition;

    return section(classes: 'section section--tint', id: 'articles', [
      div(classes: 'container', [
        SectionHeading(eyebrow: hub.eyebrow, title: hub.heading, lede: hub.lede),
        div(classes: 'articles-block', [
          h3([.text(hub.latestTitle)]),
          ol(classes: 'article-list', [
            for (final article in hub.articles)
              li(classes: 'article-item', [
                a(
                  href: article.url,
                  classes: 'article-link',
                  target: Target.blank,
                  attributes: const {'rel': 'noopener noreferrer'},
                  [
                    span(classes: 'article-meta', [.text('${article.publication} · ${article.published}')]),
                    span(classes: 'article-title', [.text(article.title)]),
                    span(classes: 'article-arrow', attributes: const {'aria-hidden': 'true'}, [.text('↗')]),
                  ],
                ),
              ]),
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
