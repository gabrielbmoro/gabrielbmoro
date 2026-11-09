import 'package:jaspr/dom.dart';
// Server-specific Jaspr import.
import 'package:jaspr/server.dart';

import 'package:gabriel_moro_site/app.dart';
import 'package:gabriel_moro_site/di/service_locator.dart';
import 'package:gabriel_moro_site/domain/models/site_links.dart';
import 'package:gabriel_moro_site/domain/repository.dart';
import 'package:gabriel_moro_site/main.server.options.dart';

/// Person + profile structured data shared by both locales.
String _personJsonLd(SiteLinks links) =>
    '''
{
  "@context": "https://schema.org",
  "@type": "Person",
  "name": "Gabriel Bronzatti Moro",
  "alternateName": "gabrielbmoro",
  "jobTitle": "Senior Mobile Engineer",
  "description": "Senior mobile engineer and tech lead working with Android, Kotlin Multiplatform and Flutter. 1:1 mentor for developers growing into senior and lead roles.",
  "url": "${links.siteUrl}",
  "image": "${links.siteUrl}assets/avatar-800.jpg",
  "worksFor": { "@type": "Organization", "name": "Kobe" },
  "alumniOf": [
    { "@type": "CollegeOrUniversity", "name": "UFRGS" },
    { "@type": "CollegeOrUniversity", "name": "UNIPAMPA" }
  ],
  "sameAs": [
    "${links.linkedInUrl}",
    "${links.gitHubUrl}",
    "${links.mediumUrl}",
    "${links.youTubeUrl}"
  ],
  "knowsAbout": [
    "Android",
    "Kotlin Multiplatform",
    "Compose Multiplatform",
    "Flutter",
    "Software Architecture",
    "Mobile Engineering"
  ]
}
''';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);
  configureDependencies();

  final repository = getIt<SiteContentRepository>();
  // The root locale is Brazilian Portuguese; English lives under /en.
  final content = repository.defaultContent;

  runApp(
    Document(
      title: content.metaTitle,
      lang: content.lang,
      // No <base> element: every asset and link is page-relative.
      base: null,
      meta: {
        'theme-color': '#F2F7EE',
        'color-scheme': 'light',
        'author': 'Gabriel Bronzatti Moro',
      },
      head: [
        meta(name: 'robots', content: 'index, follow'),
        script(
          content: _personJsonLd(content.links),
          attributes: const {'type': 'application/ld+json'},
        ),
      ],
      body: App(repository: repository),
    ),
  );
}
