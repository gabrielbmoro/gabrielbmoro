import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/ui/components/section_heading.dart';

/// Index of the site's pages, rendered on the home page.
class ExploreSection extends StatelessComponent {
  const ExploreSection({required this.page, super.key});

  final SitePage page;

  @override
  Component build(BuildContext context) {
    final explore = page.content.explore;

    return section(classes: 'section', id: 'explore', [
      div(classes: 'container', [
        SectionHeading(eyebrow: explore.eyebrow, title: explore.heading, lede: explore.lede),
        div(classes: 'page-index', [
          for (final item in page.nav)
            a(
              href: item.href,
              classes: 'page-card',
              [
                span(classes: 'page-card-head', [
                  span(classes: 'page-card-label', [.text(item.label)]),
                  span(classes: 'page-card-icon', attributes: const {'aria-hidden': 'true'}, [.text('→')]),
                ]),
                span(classes: 'page-card-summary', [.text(item.summary)]),
              ],
            ),
        ]),
      ]),
    ]);
  }
}
