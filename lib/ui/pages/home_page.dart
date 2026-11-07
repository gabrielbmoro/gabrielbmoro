import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../../components/seo_head.dart';
import '../../components/site_footer.dart';
import '../../components/site_header.dart';
import '../../domain/models/site_content.dart';
import '../sections/about.dart';
import '../sections/community.dart';
import '../sections/experience.dart';
import '../sections/hero.dart';
import '../sections/mentoring.dart';
import '../sections/toolkit.dart';
import '../sections/work.dart';

/// The single long-form page, rendered for each locale.
class HomePage extends StatelessComponent {
  const HomePage({required this.content, required this.locales, super.key});

  final SiteContent content;

  /// Every published locale, used to render the `hreflang` alternates.
  final List<SiteContent> locales;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.html(attributes: {'lang': content.lang}),
      SeoHead(content: content, locales: locales),
      a(classes: 'skip-link', href: '#main', [.text(content.skipLink)]),
      SiteHeader(content: content),
      main_(id: 'main', [
        Hero(content: content),
        AboutSection(content: content),
        MentoringSection(content: content),
        ExperienceSection(content: content),
        ToolkitSection(content: content),
        WorkSection(content: content),
        CommunitySection(content: content),
      ]),
      SiteFooter(content: content),
    ]);
  }
}
