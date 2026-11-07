import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Visual variants for call-to-action links.
enum ActionVariant { primary, ghost, light }

/// Optional glyph rendered after an action label.
enum ActionIcon { none, right, upRight }

class ActionLink extends StatelessComponent {
  const ActionLink({
    required this.href,
    required this.label,
    this.variant = ActionVariant.primary,
    this.icon = ActionIcon.none,
    this.external = false,
    this.small = false,
    super.key,
  });

  final String href;
  final String label;
  final ActionVariant variant;
  final ActionIcon icon;
  final bool external;
  final bool small;

  @override
  Component build(BuildContext context) {
    final classes = [
      'btn',
      'btn--${variant.name}',
      if (small) 'btn--small',
    ].join(' ');

    return a(
      href: href,
      classes: classes,
      target: external ? Target.blank : null,
      attributes: external ? const {'rel': 'noopener noreferrer'} : null,
      [
        .text(label),
        if (icon != ActionIcon.none)
          span(
            classes: 'btn-icon',
            attributes: const {'aria-hidden': 'true'},
            [.text(icon == ActionIcon.right ? '→' : '↗')],
          ),
      ],
    );
  }
}

class TextLink extends StatelessComponent {
  const TextLink(this.label, {required this.href, this.external = true, super.key});

  final String label;
  final String href;
  final bool external;

  @override
  Component build(BuildContext context) {
    return a(
      href: href,
      classes: 'text-link',
      target: external ? Target.blank : null,
      attributes: external ? const {'rel': 'noopener noreferrer'} : null,
      [
        .text(label),
        span(classes: 'text-link-icon', attributes: const {'aria-hidden': 'true'}, [.text('↗')]),
      ],
    );
  }
}

class SectionHeading extends StatelessComponent {
  const SectionHeading({
    required this.eyebrow,
    required this.title,
    this.lede,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String? lede;

  @override
  Component build(BuildContext context) {
    return header(classes: 'section-head', [
      p(classes: 'eyebrow', [.text(eyebrow)]),
      h2([.text(title)]),
      if (lede case final lede?) p(classes: 'section-lede', [.text(lede)]),
    ]);
  }
}

class Tag extends StatelessComponent {
  const Tag(this.label, {super.key});

  final String label;

  @override
  Component build(BuildContext context) => li(classes: 'tag', [.text(label)]);
}
