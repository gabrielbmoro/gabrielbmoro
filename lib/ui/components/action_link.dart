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
