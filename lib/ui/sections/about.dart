import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/ui/components/section_heading.dart';
import 'package:gabriel_moro_site/ui/components/text_link.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';

class AboutSection extends StatelessComponent {
  const AboutSection({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    final about = content.about;

    return section(classes: 'section', id: 'about', [
      div(classes: 'container about-content', [
        SectionHeading(eyebrow: about.eyebrow, title: about.heading),
        div(classes: 'about-media', [
          div(classes: 'portrait', [
            img(
              src: '${content.assetPrefix}assets/avatar-800.jpg',
              alt: about.portraitAlt,
              width: 800,
              height: 800,
              loading: MediaLoading.lazy,
              attributes: {
                'srcset':
                    '${content.assetPrefix}assets/avatar-400.jpg 400w, '
                    '${content.assetPrefix}assets/avatar-800.jpg 800w',
                'sizes': '(max-width: 600px) 60vw, 220px',
                'decoding': 'async',
              },
            ),
          ]),
          div(classes: 'portrait-caption', [
            p(classes: 'portrait-role', [.text(about.portraitRole)]),
            for (final entry in about.education)
              p(classes: 'portrait-education', [
                .text('${entry.degree} ${about.educationConnector} '),
                a(
                  href: entry.url,
                  target: Target.blank,
                  attributes: const {'rel': 'noopener noreferrer'},
                  [.text(entry.institution)],
                ),
              ]),
          ]),
        ]),
        p(classes: 'body-large about-intro', [.text(about.intro)]),
        for (final topic in about.sections)
          div(classes: 'about-topic', [
            h3(classes: 'about-topic-title', [.text(topic.title)]),
            for (final paragraph in topic.paragraphs) p(classes: 'body-large', [.text(paragraph)]),
          ]),
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
        div(classes: 'about-contact', [
          h3(classes: 'about-topic-title', [.text(about.contactLabel)]),
          p(classes: 'body-large', [.text(about.contactText)]),
          div(classes: 'about-contact-links', [
            TextLink(content.links.email, href: content.mailto, external: false),
            TextLink('LinkedIn', href: content.links.linkedInUrl),
            TextLink('GitHub', href: content.links.gitHubUrl),
          ]),
        ]),
      ]),
    ]);
  }
}
