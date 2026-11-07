import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

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
