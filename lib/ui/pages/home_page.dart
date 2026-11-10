import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:gabriel_moro_site/ui/components/seo_head.dart';
import 'package:gabriel_moro_site/ui/components/site_footer.dart';
import 'package:gabriel_moro_site/ui/components/site_header.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/ui/sections/about.dart';
import 'package:gabriel_moro_site/ui/sections/content_hub.dart';
import 'package:gabriel_moro_site/ui/sections/experience.dart';
import 'package:gabriel_moro_site/ui/sections/hero.dart';
import 'package:gabriel_moro_site/ui/sections/toolkit.dart';
import 'package:gabriel_moro_site/ui/sections/work.dart';

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
        ContentHubSection(content: content),
        WorkSection(content: content),
        ExperienceSection(content: content),
        ToolkitSection(content: content),
      ]),
      SiteFooter(content: content),
    ]);
  }
}
