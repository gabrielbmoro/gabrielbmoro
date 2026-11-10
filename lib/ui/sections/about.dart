import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/ui/components/section_heading.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';

class AboutSection extends StatelessComponent {
  const AboutSection({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    final about = content.about;

    return section(classes: 'section', id: 'about', [
      div(classes: 'container about-grid', [
        SectionHeading(eyebrow: about.eyebrow, title: about.heading),
        div(classes: 'about-body', [
          for (final paragraph in about.paragraphs) p(classes: 'body-large', [.text(paragraph)]),
          div(classes: 'currently', [
            p(classes: 'currently-label', [.text(about.currentlyLabel)]),
            for (final role in about.currentRoles)
              div(classes: 'currently-item', [
                p(classes: 'currently-role', [
                  if (role.url case final url?)
                    a(
                      href: url,
                      target: Target.blank,
                      attributes: const {'rel': 'noopener noreferrer'},
                      [.text(role.role)],
                    )
                  else
                    .text(role.role),
                  span(classes: 'currently-company', [.text(' · ${role.company}')]),
                ]),
                p(classes: 'currently-period', [.text(role.period)]),
              ]),
          ]),
        ]),
      ]),
    ]);
  }
}
