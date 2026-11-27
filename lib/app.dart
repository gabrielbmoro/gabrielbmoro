import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'package:gabriel_moro_site/domain/repository.dart';
import 'package:gabriel_moro_site/ui/pages/site_page.dart';

/// Static routes. Every localized page is pre-rendered at build time.
class App extends StatelessComponent {
  const App({required this.repository, super.key});

  final SiteContentRepository repository;

  @override
  Component build(BuildContext context) {
    return Router(
      routes: [
        for (final page in repository.pages)
          Route(
            path: page.route,
            builder: (_, _) => SitePageView(page: page),
          ),
      ],
    );
  }
}
