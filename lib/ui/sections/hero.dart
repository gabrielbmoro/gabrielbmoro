import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/ui/components/action_link.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';

class Hero extends StatelessComponent {
  const Hero({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    final hero = content.hero;

    return section(classes: 'hero', [
      div(classes: 'container hero-grid', [
        div(classes: 'hero-copy', [
          p(classes: 'kicker', [.text(hero.kicker)]),
          p(classes: 'availability', [
            span(classes: 'availability-dot', attributes: const {'aria-hidden': 'true'}, []),
            .text(hero.availability),
            span(classes: 'availability-divider', attributes: const {'aria-hidden': 'true'}, [.text('·')]),
            span(classes: 'availability-note', [.text(hero.availabilityNote)]),
          ]),
          h1([
            .text(hero.title),
            em([.text(hero.titleEmphasis)]),
          ]),
          p(classes: 'hero-lede', [.text(hero.lede)]),
          div(classes: 'hero-actions', [
            ActionLink(href: hero.primaryCtaHref, label: hero.primaryCta, icon: ActionIcon.right),
            ActionLink(
              href: hero.secondaryCtaHref,
              label: hero.secondaryCta,
              variant: ActionVariant.ghost,
            ),
          ]),
          p(classes: 'hero-note', [.text(hero.note)]),
          dl(classes: 'stats', [
            for (final stat in hero.stats)
              div(classes: 'stat', [
                dt([.text(stat.value)]),
                dd([.text(stat.label)]),
              ]),
          ]),
        ]),
        div(classes: 'hero-media', [
          div(classes: 'portrait', [
            img(
              src: '${content.assetPrefix}assets/avatar-800.jpg',
              alt: hero.portraitAlt,
              width: 800,
              height: 800,
              loading: MediaLoading.eager,
              attributes: {
                'srcset':
                    '${content.assetPrefix}assets/avatar-400.jpg 400w, '
                    '${content.assetPrefix}assets/avatar-800.jpg 800w',
                'sizes': '(max-width: 900px) 240px, 340px',
                'decoding': 'async',
                'fetchpriority': 'high',
              },
            ),
          ]),
          div(classes: 'portrait-caption', [
            p(classes: 'portrait-role', [.text(hero.portraitRole)]),
            p(classes: 'portrait-education', [.text(hero.portraitEducation)]),
          ]),
        ]),
      ]),
    ]);
  }
}
