import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Tag extends StatelessComponent {
  const Tag(this.label, {super.key});

  final String label;

  @override
  Component build(BuildContext context) => li(classes: 'tag', [.text(label)]);
}
