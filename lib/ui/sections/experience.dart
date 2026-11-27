import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/ui/components/section_heading.dart';
import 'package:gabriel_moro_site/ui/components/text_link.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';

class ExperienceSection extends StatelessComponent {
  const ExperienceSection({required this.page, super.key});

  final SitePage page;

  @override
  Component build(BuildContext context) {
    final content = page.content;
    final experience = content.experience;

    return section(classes: 'section', id: 'experience', [
      div(classes: 'container', [
        SectionHeading(
          eyebrow: experience.eyebrow,
          title: experience.heading,
          lede: experience.lede,
        ),
        ol(classes: 'roles', [
          for (final role in experience.roles)
            li(classes: 'role', [
              p(classes: 'role-period', [.text(role.period)]),
              div(classes: 'role-main', [
                p(classes: 'role-company', [.text(role.company)]),
                h3([.text(role.title)]),
                ul(classes: 'bullet-list', [
                  for (final bullet in role.bullets) li([.text(bullet)]),
                ]),
              ]),
            ]),
        ]),
        p(classes: 'section-foot', [
          TextLink(experience.linkLabel, href: page.content.links.linkedInUrl),
        ]),
      ]),
    ]);
  }
}
