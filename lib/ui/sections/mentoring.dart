import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/ui/components/action_link.dart';
import 'package:gabriel_moro_site/ui/components/section_heading.dart';

/// The mentoring page: who it is for, what we work on, how it runs and the
/// closing invitation to book the free intro call.
class MentoringSection extends StatelessComponent {
  const MentoringSection({required this.page, super.key});

  final SitePage page;

  @override
  Component build(BuildContext context) {
    final mentoring = page.content.mentoring;

    return section(classes: 'section', id: 'mentoring', [
      div(classes: 'container', [
        SectionHeading(eyebrow: mentoring.eyebrow, title: mentoring.heading, lede: mentoring.lede),
        div(classes: 'mentoring-status', [
          p(classes: 'availability mentoring-availability', [
            span(classes: 'availability-dot', attributes: const {'aria-hidden': 'true'}, []),
            .text(mentoring.availability),
            span(classes: 'availability-divider', attributes: const {'aria-hidden': 'true'}, [.text('·')]),
            span(classes: 'availability-note', [.text(mentoring.availabilityNote)]),
          ]),
          div(classes: 'mentoring-actions', [
            ActionLink(href: mentoring.primaryCtaHref, label: mentoring.primaryCta, icon: ActionIcon.right),
          ]),
          p(classes: 'mentoring-cta-note', [.text(mentoring.ctaNote)]),
        ]),
        div(classes: 'mentoring-block', [
          h3([.text(mentoring.audienceTitle)]),
          ul(classes: 'bullet-list', [
            for (final item in mentoring.audience) li([.text(item)]),
          ]),
        ]),
        div(classes: 'mentoring-block', [
          h3([.text(mentoring.topicsTitle)]),
          dl(classes: 'toolkit', [
            for (final topic in mentoring.topics)
              div(classes: 'toolkit-group', [
                dt([.text(topic.label)]),
                dd([.text(topic.description)]),
              ]),
          ]),
        ]),
        div(classes: 'mentoring-block', [
          h3([.text(mentoring.stepsTitle)]),
          ol(classes: 'mentoring-steps', [
            for (var index = 0; index < mentoring.steps.length; index++)
              li(classes: 'mentoring-step', [
                p(classes: 'mentoring-step-label', [.text('${index + 1}'.padLeft(2, '0'))]),
                h4([.text(mentoring.steps[index].title)]),
                p([.text(mentoring.steps[index].description)]),
              ]),
          ]),
        ]),
        div(classes: 'mentoring-block', [
          h3([.text(mentoring.outcomesTitle)]),
          ul(classes: 'bullet-list', [
            for (final item in mentoring.outcomes) li([.text(item)]),
          ]),
        ]),
        div(classes: 'cta-band', [
          p(classes: 'cta-title', [.text(mentoring.closingTitle)]),
          p(classes: 'cta-text', [.text(mentoring.closingText)]),
          ActionLink(href: mentoring.closingHref, label: mentoring.closingCta, icon: ActionIcon.right),
        ]),
      ]),
    ]);
  }
}
