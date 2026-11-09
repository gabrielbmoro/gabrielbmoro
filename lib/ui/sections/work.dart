import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/ui/components/section_heading.dart';
import 'package:gabriel_moro_site/ui/components/tag.dart';
import 'package:gabriel_moro_site/ui/components/text_link.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';

class WorkSection extends StatelessComponent {
  const WorkSection({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    final work = content.work;

    return section(classes: 'section', id: 'work', [
      div(classes: 'container', [
        SectionHeading(eyebrow: work.eyebrow, title: work.heading, lede: work.lede),
        div(classes: 'work-grid', [
          for (final project in work.projects)
            article(classes: 'work-card', [
              h3([.text(project.name)]),
              p(classes: 'work-description', [.text(project.description)]),
              ul(classes: 'tags', [
                for (final tag in project.tags) Tag(tag),
              ]),
              TextLink(project.linkLabel, href: project.url),
            ]),
        ]),
      ]),
    ]);
  }
}
