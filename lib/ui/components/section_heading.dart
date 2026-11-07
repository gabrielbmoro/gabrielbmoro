import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

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
