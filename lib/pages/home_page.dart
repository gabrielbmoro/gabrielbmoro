import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/seo_head.dart';
import '../components/site_footer.dart';
import '../components/site_header.dart';
import '../content/site_content.dart';
import '../sections/about.dart';
import '../sections/community.dart';
import '../sections/experience.dart';
import '../sections/hero.dart';
import '../sections/mentoring.dart';
import '../sections/toolkit.dart';
import '../sections/work.dart';

/// The single long-form page, rendered for each locale.
class HomePage extends StatelessComponent {
  const HomePage({required this.content, super.key});

  final SiteContent content;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.html(attributes: {'lang': content.lang}),
      SeoHead(content: content),
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
