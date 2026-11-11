# gabrielbmoro — personal site & GitHub profile

This repository holds two things:

1. **The personal site** — a bilingual (English / Brazilian Portuguese) landing page for
   Gabriel Moro, built with [Jaspr](https://jaspr.site/) in static mode, and published with
   GitHub Pages at <https://gabrielbmoro.dev/>.
2. **The GitHub profile READMEs** — `README.md` and `README_ptBr.md`, rendered on
   <https://github.com/gabrielbmoro>.

Jekyll is gone. Do not reintroduce `_config.yml`, `remote_theme`, or GitHub Pages
"deploy from a branch". The site is built with Dart and deployed from GitHub Actions.

## Stack

- Dart (SDK `^3.10.0`) + Jaspr `0.23.x`, `jaspr_router` for the `/` (PT-BR, default) and `/en` routes.
- Static mode: `jaspr build` pre-renders both routes to HTML.
- `get_it` wires the JSON data source and repository at startup.
- Plain CSS in `web/site.css`, self-hosted Inter + Montaga in `web/fonts/`.
- No client-side JavaScript is shipped: the site is entirely pre-rendered.

## Layout

```
lib/
  main.server.dart              # composition root: repository, Document <head>, JSON-LD, <body>
  app.dart                      # Router derived from the repository's locales
  domain/
    models/site_content.dart    # immutable content data classes (no copy)
    models/site_links.dart      # canonical URLs and contact email
    repository.dart             # SiteContentRepository abstraction
  data/
    repository_impl.dart        # SiteContentRepository implementation
    site_content_data_source.dart # data-source contract
    json_site_content_data_source.dart # reads assets/content/*.json
  di/service_locator.dart       # GetIt registrations (data source + repository)
  ui/
    components/                 # header, footer, SEO head, shared UI
    pages/home_page.dart        # composes the page for a locale
    sections/                   # hero, about, content hub, experience, toolkit, work
assets/content/
  en.json                       # ALL visible English copy, links and SEO data
  pt-br.json                    # ALL visible PT-BR copy, links and SEO data
web/
  site.css                      # design system and responsive rules
  fonts/                        # self-hosted woff2 files + attribution
  assets/                       # optimized avatar, icons, masthead cover and article covers
  favicon.svg, robots.txt
```

## Commands

Jaspr is driven by the `jaspr` CLI:

```sh
dart pub global activate jaspr_cli 0.23.5
dart pub get
jaspr serve                 # local dev server on http://localhost:8080
jaspr build                 # static output in build/jaspr
dart format lib
dart analyze

# Architecture checks. Eagle Eye lives in an isolated tool package because it
# pins analyzer 8 while Jaspr 0.23 pins analyzer 12.
dart pub get --directory tool/eagle_eye
dart run --packages=tool/eagle_eye/.dart_tool/package_config.json tool/eagle_eye/bin/run.dart
```

`jaspr serve` prints a warning about a missing `main.client.dart`; that is expected — the site
intentionally has no client entrypoint and ships zero JavaScript.

The GitHub Actions workflow runs `dart format --output=none --set-exit-if-changed lib`,
`dart analyze`, the Eagle Eye architecture check, and `jaspr build`, prunes compiler caches
(`build/jaspr/packages`,
`build/jaspr/.dart_tool`, `build/jaspr/.build.manifest`) from the artifact, then deploys
`build/jaspr`.

## Deployment

- Pages source **must** be set to **GitHub Actions** in the repository settings, not a branch.
- The workflow `.github/workflows/deploy-site.yml` publishes on pushes to `master`, builds on
  pull requests, and can be run manually.
- The site is served at <https://gabrielbmoro.dev/> from a custom domain pinned in `web/CNAME`.
  The workflow also writes `build/jaspr/CNAME` into the artifact, because Pages only publishes
  the domain carried by the deployed files. Keep that name, `web/CNAME`, the `Sitemap:` line in
  `web/robots.txt` and the JSON `canonicalUrl` / `links.siteUrl` fields in sync.
- All site URLs are page-relative (`site.css`, `../site.css`, `en/`, `../`), so the site works
  both at the domain root and at `/` during local development, without a `<base>` element or a
  build-time base flag. Keep new asset links relative; if you add a `<base>` tag, anchors will
  break.
- Canonical and Open Graph URLs live in the `links` and `canonicalUrl` fields of both JSON
  content assets; update both if the domain or repository name changes.

## Content conventions

- Change copy in `assets/content/en.json` and `assets/content/pt-br.json`, never in the section
  widgets.
- Brazilian Portuguese is the default locale: it is published at `/`, English at `/en`. The
  locale whose `route` is `/` is served at the site root, used for the document language and as
  the `x-default` / Open Graph target; `SiteContentRepository.defaultContent` exposes it.
- Every user-facing string exists in both JSON assets. Keep the two locales in sync and natural —
  Portuguese is not a literal word-for-word translation. The shared `links` blocks must stay
  identical; the data source fails the build otherwise.
- `lib/domain/` holds plain data classes and the `SiteContentRepository` abstraction; it must not
  import `lib/data/`, Jaspr, or DOM code.
- Register infrastructure dependencies in `lib/di/service_locator.dart`; UI widgets keep receiving
  their dependencies through constructors instead of resolving them from GetIt.
- Sections are `lib/ui/sections/*.dart`; each takes `SiteContent` and reads its own slice. Locales are
  discovered through `SiteContentRepository.contents`, so the router and the `hreflang` alternates
  follow the repository.
- The masthead is the site identity: the bugdroid-with-cuia emblem, `siteTitle` (the wordmark) and
  `tagline` are top-level fields in each JSON asset, followed by a tab bar built from `nav`,
  `navCta` and the locale switch.
- The page is a single column. Sections, article cards, projects, channels, toolkit rows and the
  footer stack vertically; do not reintroduce side-by-side column layouts.
- Keep the design quiet: deep forest canvas, sage ink, green accent, Montaga display + Inter body.
  Montaga ships a single 400 weight, so headings express hierarchy through size and spacing, never
  synthetic bold. Font sizes are expressed in `rem` on top of a `106.25%` root (17px), so legibility
  is tuned in one place instead of dozens of pixel values.
  Avoid adding a UI framework or a JavaScript dependency for presentation.
- `README.md` and `README_ptBr.md` must stay in sync (see `README.md` conventions):
  the user is **Moro** / **gabrielbmoro**.

## Assets

- `web/assets/avatar-400.jpg` and `avatar-800.jpg` are tight crops of
  `assets/img/avatar.png`; regenerate both if the photo changes. Keep the 800px file under
  ~100 KB and the 400px under ~30 KB.
- `web/assets/masthead-cover.jpg` is the decorative masthead banner (1376×768, progressive JPEG,
  target under ~150 KB). It is a deep-forest pattern of the bugdroid-with-cuia mark; it is
  referenced by the top-level `coverImage` field in both JSON assets, using a path relative to the
  site root; `null` falls back to the CSS-only cover.
- `web/assets/logo-mark.png` is the transparent bugdroid-with-cuia mark extracted from the banner.
  It is the masthead emblem (`.masthead-mark`, a small framed tile above the wordmark); keep the
  transparent background so it sits on the masthead tile.
- `web/assets/articles/*.jpg` are 480×270 16:9 covers for the article list, cropped centrally from
  each article's `og:image` (progressive JPEG, target under ~45 KB). Point an article at one with
  `content.articles[].thumbnail`, using a path relative to the site root; localized article lists
  may link to different posts, so the thumbnail may differ per locale too.
- `web/favicon.svg`, `web/favicon.ico`, and `web/assets/apple-touch-icon.png` share a tab-first
  bugdroid-with-cuia emblem on a forest rounded-square. The SVG is the source and is drawn for
  16 px legibility, not as a miniature of `logo-mark.png`; the ICO carries 16/32/48 px renders,
  and the touch icon is a full-bleed 180 px square. The icon links in `seo_head.dart` carry a
  `?v=` cache-buster — bump `_faviconVersion` whenever the artwork changes.
- Font licenses: SIL OFL 1.1; see `web/fonts/ATTRIBUTION.txt` and `web/fonts/OFL.txt`.
