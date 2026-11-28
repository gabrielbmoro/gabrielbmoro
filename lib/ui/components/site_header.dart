import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/domain/models/site_content.dart';

/// Full-bleed masthead: cover artwork, site wordmark, tagline and the tab bar.
class SiteHeader extends StatelessComponent {
  const SiteHeader({required this.page, super.key});

  final SitePage page;

  @override
  Component build(BuildContext context) {
    final content = page.content;

    return header(classes: 'masthead', [
      div(
        classes: 'masthead-cover',
        attributes: const {'aria-hidden': 'true'},
        [
          if (content.coverImage case final cover?)
            img(
              src: '${page.assetPrefix}$cover',
              alt: '',
              loading: MediaLoading.eager,
              attributes: const {'fetchpriority': 'high', 'decoding': 'async'},
            ),
        ],
      ),
      div(classes: 'container masthead-inner', [
        img(
          src: '${page.assetPrefix}assets/avatar-800.jpg',
          alt: '',
          width: 800,
          height: 800,
          classes: 'masthead-mark',
          loading: MediaLoading.eager,
          attributes: {
            'srcset':
                '${page.assetPrefix}assets/avatar-400.jpg 400w, '
                '${page.assetPrefix}assets/avatar-800.jpg 800w',
            'sizes': '248px',
            'decoding': 'async',
          },
        ),
        h1(classes: 'masthead-title', [
          a(
            href: page.homeHref,
            attributes: {'aria-label': content.homeLabel},
            [.text(content.siteTitle)],
          ),
        ]),
        p(classes: 'masthead-tagline', [.text(content.tagline)]),
      ]),
      nav(
        classes: 'masthead-tabs',
        attributes: {'aria-label': content.navAriaLabel},
        [
          div(classes: 'container masthead-tabs-inner', [
            for (final item in page.nav)
              a(
                href: item.href,
                classes: item.current ? 'tab tab--active' : 'tab',
                attributes: item.current ? const {'aria-current': 'page'} : null,
                [.text(item.label)],
              ),
            a(
              href: page.switchHref,
              classes: 'tab tab--lang',
              attributes: {
                'aria-label': content.switchAriaLabel,
                'hreflang': content.switchHrefLang,
                'lang': content.switchHrefLang,
              },
              [.text(content.switchLabel)],
            ),
          ]),
        ],
      ),
    ]);
  }
}
