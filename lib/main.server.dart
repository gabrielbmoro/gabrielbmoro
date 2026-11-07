import 'package:jaspr/dom.dart';
// Server-specific Jaspr import.
import 'package:jaspr/server.dart';

import 'app.dart';
import 'content/site_content.dart';
import 'main.server.options.dart';

/// Person + profile structured data shared by both locales.
const _personJsonLd =
    '''
{
  "@context": "https://schema.org",
  "@type": "Person",
  "name": "Gabriel Bronzatti Moro",
  "alternateName": "gabrielbmoro",
  "jobTitle": "Senior Mobile Engineer",
  "description": "Senior mobile engineer and tech lead working with Android, Kotlin Multiplatform and Flutter. 1:1 mentor for developers growing into senior and lead roles.",
  "url": "$siteUrl",
  "image": "${siteUrl}assets/avatar-800.jpg",
  "worksFor": { "@type": "Organization", "name": "Kobe" },
  "alumniOf": [
    { "@type": "CollegeOrUniversity", "name": "UFRGS" },
    { "@type": "CollegeOrUniversity", "name": "UNIPAMPA" }
  ],
  "sameAs": [
    "$linkedInUrl",
    "$gitHubUrl",
    "$mediumUrl",
    "$youTubeUrl"
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

  runApp(
    Document(
      title: SiteContent.en.metaTitle,
      lang: 'en',
      // No <base> element: every asset and link is page-relative.
      base: null,
      meta: {
        'theme-color': '#F7F5F0',
        'color-scheme': 'light',
        'author': 'Gabriel Bronzatti Moro',
      },
      head: [
        meta(name: 'robots', content: 'index, follow'),
        script(
          content: _personJsonLd,
          attributes: const {'type': 'application/ld+json'},
        ),
      ],
      body: const App(),
    ),
  );
}
