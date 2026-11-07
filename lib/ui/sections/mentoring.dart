import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/action_link.dart';
import '../components/section_heading.dart';
import '../../domain/models/site_content.dart';

class MentoringSection extends StatelessComponent {
  const MentoringSection({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    final mentoring = content.mentoring;

    return section(classes: 'section section--tint', id: 'mentoring', [
      div(classes: 'container', [
        SectionHeading(
          eyebrow: mentoring.eyebrow,
          title: mentoring.heading,
          lede: mentoring.lede,
        ),
        div(classes: 'mentor-grid', [
          article(classes: 'panel', [
            h3([.text(mentoring.forYouTitle)]),
            ul(classes: 'bullet-list', [
              for (final item in mentoring.forYou) li([.text(item)]),
            ]),
            p(classes: 'panel-note', [
              .text('${mentoring.forYouNote} '),
              a(href: content.mailto, [
                .text(mentoring.forYouNoteCta),
                span(classes: 'panel-note-icon', attributes: const {'aria-hidden': 'true'}, [.text('→')]),
              ]),
            ]),
          ]),
          article(classes: 'panel', [
            h3([.text(mentoring.focusTitle)]),
            dl(classes: 'focus-list', [
              for (final area in mentoring.focusAreas)
                div(classes: 'focus-item', [
                  dt([.text(area.title)]),
                  dd([.text(area.description)]),
                ]),
            ]),
          ]),
        ]),
        div(classes: 'steps-block', [
          h3([.text(mentoring.stepsTitle)]),
          ol(classes: 'steps', [
            for (var index = 0; index < mentoring.steps.length; index++)
              li(classes: 'step', [
                span(
                  classes: 'step-index',
                  attributes: const {'aria-hidden': 'true'},
                  [.text('${index + 1}'.padLeft(2, '0'))],
                ),
                div(classes: 'step-body', [
                  h4([.text(mentoring.steps[index].title)]),
                  p([.text(mentoring.steps[index].description)]),
                ]),
              ]),
          ]),
          p(classes: 'steps-note', [.text(mentoring.stepsNote)]),
        ]),
        div(classes: 'get-block', [
          h3([.text(mentoring.getTitle)]),
          ul(classes: 'check-list', [
            for (final item in mentoring.getItems)
              li([
                span(classes: 'check', attributes: const {'aria-hidden': 'true'}, [.text('✓')]),
                .text(item),
              ]),
          ]),
        ]),
        div(classes: 'cta-band', [
          div(classes: 'cta-copy', [
            p(classes: 'cta-title', [.text(mentoring.ctaTitle)]),
            p(classes: 'cta-text', [.text(mentoring.ctaText)]),
          ]),
          ActionLink(href: content.mailto, label: mentoring.ctaButton, icon: ActionIcon.right),
        ]),
      ]),
    ]);
  }
}
