import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/ui/components/section_heading.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';

class ToolkitSection extends StatelessComponent {
  const ToolkitSection({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    final toolkit = content.toolkit;

    return section(classes: 'section section--tight', id: 'toolkit', [
      div(classes: 'container', [
        SectionHeading(eyebrow: toolkit.eyebrow, title: toolkit.heading),
        dl(classes: 'toolkit', [
          for (final group in toolkit.groups)
            div(classes: 'toolkit-group', [
              dt([.text(group.label)]),
              dd([.text(group.value)]),
            ]),
        ]),
      ]),
    ]);
  }
}
