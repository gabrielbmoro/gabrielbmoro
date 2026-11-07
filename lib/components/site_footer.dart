import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../domain/models/site_content.dart';
import 'ui.dart';

class SiteFooter extends StatelessComponent {
  const SiteFooter({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    final copy = content.footer;

    return footer(classes: 'site-footer', [
      div(classes: 'container footer-top', [
        div(classes: 'footer-copy', [
          p(classes: 'availability availability--footer', [
            span(classes: 'availability-dot', attributes: const {'aria-hidden': 'true'}, []),
            .text(copy.availability),
          ]),
          h2([.text(copy.heading)]),
          p(classes: 'footer-text', [.text(copy.text)]),
        ]),
        div(classes: 'footer-actions', [
          ActionLink(
            href: content.mailto,
            label: copy.cta,
            variant: ActionVariant.light,
            icon: ActionIcon.right,
          ),
          a(href: 'mailto:${content.links.email}', classes: 'footer-email', [.text(content.links.email)]),
        ]),
      ]),
      div(classes: 'container footer-bottom', [
        div(classes: 'footer-legal', [
          p([.text(copy.copyright)]),
          p([.text(copy.builtWith)]),
        ]),
        nav(
          classes: 'footer-links',
          attributes: {'aria-label': content.socialAriaLabel},
          [
            for (final link in copy.links)
              a(
                href: link.url,
                target: Target.blank,
                attributes: const {'rel': 'noopener noreferrer'},
                [.text(link.label)],
              ),
          ],
        ),
        a(
          href: content.switchHref,
          classes: 'lang-switch lang-switch--footer',
          attributes: {
            'aria-label': content.switchAriaLabel,
            'hreflang': content.switchHrefLang,
            'lang': content.switchHrefLang,
          },
          [.text(content.switchLabel)],
        ),
      ]),
    ]);
  }
}
