import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'content/site_content.dart';
import 'pages/home_page.dart';

/// Static routes. Both locales are pre-rendered at build time.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return Router(
      routes: [
        Route(
          path: SiteContent.en.route,
          builder: (_, _) => const HomePage(content: SiteContent.en),
        ),
        Route(
          path: SiteContent.ptBr.route,
          builder: (_, _) => const HomePage(content: SiteContent.ptBr),
        ),
      ],
    );
  }
}
