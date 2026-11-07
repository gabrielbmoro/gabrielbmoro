import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/ui.dart';
import '../content/site_content.dart';

class CommunitySection extends StatelessComponent {
  const CommunitySection({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    final community = content.community;

    return section(classes: 'section section--tight', id: 'writing', [
      div(classes: 'container', [
        SectionHeading(eyebrow: community.eyebrow, title: community.heading),
        ul(classes: 'community', [
          for (final item in community.items)
            li(classes: 'community-item', [
              h3(classes: 'community-label', [.text(item.label)]),
              p(classes: 'community-description', [.text(item.description)]),
              if (item.links.isNotEmpty)
                div(classes: 'community-links', [
                  for (final link in item.links) TextLink(link.label, href: link.url),
                ]),
            ]),
        ]),
      ]),
    ]);
  }
}
