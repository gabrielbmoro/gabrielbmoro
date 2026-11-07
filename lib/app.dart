import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'domain/repository.dart';
import 'pages/home_page.dart';

/// Static routes. Both locales are pre-rendered at build time.
class App extends StatelessComponent {
  const App({required this.repository, super.key});

  final SiteContentRepository repository;

  @override
  Component build(BuildContext context) {
    final contents = repository.contents;

    return Router(
      routes: [
        for (final content in contents)
          Route(
            path: content.route,
            builder: (_, _) => HomePage(content: content, locales: contents),
          ),
      ],
    );
  }
}
