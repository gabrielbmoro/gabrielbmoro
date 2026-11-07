import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/ui.dart';
import '../content/site_content.dart';

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
            p(classes: 'currently-role', [
              .text(about.currentlyRole),
              span(classes: 'currently-company', [.text(' · ${about.currentlyCompany}')]),
            ]),
            p(classes: 'currently-period', [.text(about.currentlyPeriod)]),
          ]),
        ]),
      ]),
    ]);
  }
}
