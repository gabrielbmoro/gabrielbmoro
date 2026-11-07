import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../content/site_content.dart';
import 'ui.dart';

class SiteHeader extends StatelessComponent {
  const SiteHeader({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    return header(classes: 'site-header', [
      div(classes: 'container header-inner', [
        a(
          href: content.homeHref,
          classes: 'brand',
          attributes: {'aria-label': content.homeLabel},
          [
            span(classes: 'brand-mark', attributes: const {'aria-hidden': 'true'}, [.text('GM')]),
            span(classes: 'brand-copy', [
              span(classes: 'brand-name', [.text('Gabriel Moro')]),
              span(classes: 'brand-role', [.text(content.brandRole)]),
            ]),
          ],
        ),
        nav(
          classes: 'site-nav',
          attributes: {'aria-label': content.navAriaLabel},
          [
            for (final item in content.nav) a(href: item.href, classes: 'site-nav-link', [.text(item.label)]),
          ],
        ),
        div(classes: 'header-actions', [
          a(
            href: content.switchHref,
            classes: 'lang-switch',
            attributes: {
              'aria-label': content.switchAriaLabel,
              'hreflang': content.switchHrefLang,
              'lang': content.switchHrefLang,
            },
            [.text(content.switchLabel)],
          ),
          ActionLink(href: content.mailto, label: content.navCta, small: true),
        ]),
      ]),
    ]);
  }
}
