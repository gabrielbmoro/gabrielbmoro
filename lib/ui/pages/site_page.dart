import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/ui/components/seo_head.dart';
import 'package:gabriel_moro_site/ui/components/site_footer.dart';
import 'package:gabriel_moro_site/ui/components/site_header.dart';
import 'package:gabriel_moro_site/ui/sections/about.dart';
import 'package:gabriel_moro_site/ui/sections/content_hub.dart';
import 'package:gabriel_moro_site/ui/sections/experience.dart';
import 'package:gabriel_moro_site/ui/sections/explore.dart';
import 'package:gabriel_moro_site/ui/sections/hero.dart';
import 'package:gabriel_moro_site/ui/sections/mentoring.dart';
import 'package:gabriel_moro_site/ui/sections/toolkit.dart';
import 'package:gabriel_moro_site/ui/sections/work.dart';

/// Renders one localized page: document head, masthead, body and footer.
///
/// The page identity selects which sections make up its body; the masthead and
/// footer are shared by every page.
class SitePageView extends StatelessComponent {
  const SitePageView({required this.page, super.key});

  final SitePage page;

  @override
  Component build(BuildContext context) {
    final content = page.content;

    return Component.fragment([
      Document.html(attributes: {'lang': content.lang}),
      SeoHead(page: page),
      a(classes: 'skip-link', href: '#main', [.text(content.skipLink)]),
      SiteHeader(page: page),
      main_(id: 'main', _sections()),
      SiteFooter(page: page),
    ]);
  }

  List<Component> _sections() => switch (page.id) {
    PageId.home => [Hero(page: page), ExploreSection(page: page)],
    PageId.about => [AboutSection(page: page)],
    PageId.articles => [ContentHubSection(page: page)],
    PageId.work => [WorkSection(page: page)],
    PageId.experience => [ExperienceSection(page: page), ToolkitSection(page: page)],
    PageId.mentoring => [MentoringSection(page: page)],
  };
}
