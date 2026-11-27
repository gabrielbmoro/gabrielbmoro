# gabrielbmoro — personal site & GitHub profile

This repository holds two things:

1. **The personal site** — a bilingual (English / Brazilian Portuguese) multi-page site for
   Gabriel Moro, built with [Jaspr](https://jaspr.site/) in static mode, and published with
   GitHub Pages at <https://gabrielbmoro.dev/>.
2. **The GitHub profile READMEs** — `README.md` and `README_ptBr.md`, rendered on
   <https://github.com/gabrielbmoro>.

Jekyll is gone. Do not reintroduce `_config.yml`, `remote_theme`, or GitHub Pages
"deploy from a branch". The site is built with Dart and deployed from GitHub Actions.

## Stack

- Dart (SDK `^3.10.0`) + Jaspr `0.23.x`, `jaspr_router` for every localized page:
  `/`, `/sobre`, `/artigos`, `/open-source`, `/experiencia`, `/mentoria`, and their
  `/en/...` counterparts.
- Static mode: `jaspr build` pre-renders every declared page to HTML.
- `get_it` wires the two independent data sources (JSON content + Medium articles) and the
  repository that composes them at startup.
- Plain CSS in `web/site.css`, self-hosted Inter + Montaga in `web/fonts/`.
- No client-side JavaScript is shipped: the site is entirely pre-rendered and the article
  filter is CSS-only (`:has()` + radio inputs).

## Layout

```
lib/
  main.server.dart              # composition root: repository, Document <head>, JSON-LD, <body>
  app.dart                      # Router built from the repository's pages
  domain/
    models/site_content.dart    # immutable content models; copy lives in assets/content
    models/site_links.dart      # canonical URLs and contact email
    site_paths.dart             # page-relative hrefs and canonical URLs
    repository.dart             # SiteContentRepository abstraction
  data/
    repository_impl.dart        # loads both data sources and attaches Medium articles to the pages
    site_content_data_source.dart # data-source contract, returns content + pages
    json_site_content_data_source.dart # reads assets/content/*.json, resolves routes and links
    medium_article_source.dart  # Medium data source: fetches and parses the Koin Developers + CodandoTV RSS feeds
    article_source.dart         # source ids/labels shared by the Medium feeds and the CSS filter
  di/service_locator.dart       # GetIt registrations (two data sources + repository)
  ui/
    components/                 # header, footer, SEO head, shared UI
    pages/site_page.dart        # page shell: head, skip link, masthead, body, footer
    sections/                   # hero, explore, about, content hub, experience, toolkit, work, mentoring
assets/content/
  en.json                       # ALL visible English copy, page routes/SEO data, links
  pt-br.json                    # ALL visible PT-BR copy, page routes/SEO data, links
test/                           # Medium parser, content source and repository composition tests
web/
  site.css                      # design system and responsive rules
  fonts/                        # self-hosted woff2 files + attribution
  assets/                       # optimized avatar, about talk photo, icons and masthead cover
  favicon.svg, robots.txt
```

## Commands

Jaspr is driven by the `jaspr` CLI:

```sh
dart pub global activate jaspr_cli 0.23.5
dart pub get
jaspr serve                 # local dev server on http://localhost:8080
jaspr build                 # static output in build/jaspr
dart format lib test
dart analyze
dart test

# Offline builds skip the Medium fetch; the article list stays empty.
SITE_SKIP_MEDIUM_FEEDS=1 jaspr build

# Architecture checks. Eagle Eye lives in an isolated tool package because it
# pins analyzer 8 while Jaspr 0.23 pins analyzer 12.
dart pub get --directory tool/eagle_eye
dart run --packages=tool/eagle_eye/.dart_tool/package_config.json tool/eagle_eye/bin/run.dart
```

`jaspr serve` prints a warning about a missing `main.client.dart`; that is expected — the site
intentionally has no client entrypoint and ships zero JavaScript.

The GitHub Actions workflow runs `dart format --output=none --set-exit-if-changed lib test`,
`dart analyze`, `dart test`, the Eagle Eye architecture check, and `jaspr build`, prunes compiler
caches (`build/jaspr/packages`, `build/jaspr/.dart_tool`, `build/jaspr/.build.manifest`) from the
artifact, then deploys `build/jaspr`. The build fetches the two Medium feeds; a feed outage only
logs a warning and publishes an empty article list.

## Deployment

- Pages source **must** be set to **GitHub Actions** in the repository settings, not a branch.
- The workflow `.github/workflows/deploy-site.yml` publishes on pushes to `master`, builds on
  pull requests, and can be run manually.
- The site is served at <https://gabrielbmoro.dev/> from a custom domain pinned in `web/CNAME`.
  The workflow also writes `build/jaspr/CNAME` into the artifact, because Pages only publishes
  the domain carried by the deployed files. Keep that name, `web/CNAME`, the `Sitemap:` line in
  `web/robots.txt` and the `links.siteUrl` field in both content assets in sync.
- All site URLs are page-relative (`site.css`, `../site.css`, `en/`, `../`), so the site works
  both at the domain root and at `/` during local development, without a `<base>` element or a
  build-time base flag. `lib/domain/site_paths.dart` derives every asset prefix, tab href, locale
  switch and canonical URL from the page route; keep new links relative and never hardcode them
  in JSON or widgets. If you add a `<base>` tag, anchors will break.
- Canonical and Open Graph URLs are derived from `links.siteUrl` plus each page's route, and each
  page owns its `<title>`, description and `hreflang` alternates. Update both content assets if
  the domain or repository name changes.
- `jaspr build` emits a sitemap with one entry per page; the workflow normalizes those URLs to a
  trailing slash so they match the canonicals.

## Content conventions

- Change copy in `assets/content/en.json` and `assets/content/pt-br.json`, never in the section
  widgets.
- Brazilian Portuguese is the default locale: it is published at `/`, English at `/en`. The
  locale whose `route` is `/` is served at the site root, used for the document language and as
  the `x-default` / Open Graph target; `SiteContentRepository.defaultContent` exposes it.
- Every user-facing string exists in both JSON assets. Keep the two locales in sync and natural —
  Portuguese is not a literal word-for-word translation. The shared `links` blocks must stay
  identical; the data source fails the build otherwise.
- Articles are not stored in the content assets. `content` in each JSON asset keeps only the
  section copy, `articleMonths`, `filterAllLabel` and `filterAriaLabel`;
  `JsonSiteContentDataSource` returns an empty article list. Gabriel's posts come exclusively
  from the Koin Developers + CodandoTV RSS feeds through `MediumArticleSource`; the two data
  sources never import each other. `SiteContentRepositoryImpl` loads both, keeps feed items only
  for `mediumAuthorName`, sorts them newest first, and rebuilds the pages so they see the
  Medium-derived list. A feed failure logs a warning and publishes an empty article list;
  `SITE_SKIP_MEDIUM_FEEDS=1` skips fetching entirely.
- Filter chips are generated from the Medium list and their source ids
  (`koin-developers`, `codandotv`) are static CSS selectors in `web/site.css` — adding a source
  means updating `article_source.dart` and the CSS rules. Article covers are absolute Medium
  WebP URLs; there are no local article thumbnails to curate.
- The article filter is CSS-only: radio inputs plus `:has()` hide non-matching cards. There is no
  JavaScript, no client entrypoint, and no URL state for the selected filter.
- Each locale JSON declares a `pages` array in tab order. Every page carries an `id` (one of the
  `PageId` values), a localized `path` below the locale root (`''` for the home page), a `title`
  and a `description`; pages in the tab bar also carry `navLabel` and a one-line `summary` for the
  home page index. Both locales must declare the same page ids in the same order, or the build
  fails. Page routes, asset prefixes, canonical URLs, `hreflang` alternates, tab hrefs and the
  locale switch are computed by the data source from those paths — never hardcode them.
- Adding a page means adding a `PageId` value, a `pages` entry in **both** locales, and its body
  composition in `SitePageView._sections` (`lib/ui/pages/site_page.dart`). The router picks it up
  from `SiteContentRepository.pages`, so there is no separate route list to edit.
- `lib/domain/` holds plain data classes and the `SiteContentRepository` abstraction; it must not
  import `lib/data/`, Jaspr, or DOM code.
- Register infrastructure dependencies in `lib/di/service_locator.dart`; UI widgets keep receiving
  their dependencies through constructors instead of resolving them from GetIt.
- Sections are `lib/ui/sections/*.dart`; each takes a `SitePage` and reads its slice from
  `page.content`, using `page.assetPrefix` for images. Pages are discovered through
  `SiteContentRepository.pages`, so the router and the `hreflang` alternates follow the
  repository.
- The masthead is the site identity: the avatar emblem, `siteTitle` (the wordmark) and
  `tagline` are top-level fields in each JSON asset, followed by a tab bar built from the pages
  that carry a `navLabel`, plus `navCta` and the locale switch. The current tab links to its own
  page and carries `aria-current="page"`.
- Each page is a single column, with one exception: the About intro grid places the talk photo
  beside the running text on wide screens and stacks it above the text under 900 px. Sections,
  article cards, projects, channels, toolkit rows and the footer stack vertically; do not
  reintroduce other side-by-side column layouts.
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
  ~100 KB and the 400px under ~30 KB. `avatar-800.jpg` is also the masthead emblem
  (`.masthead-mark`, a circular photo above the wordmark) and the Open
  Graph / JSON-LD image.
- `web/assets/talk-800.jpg` (800×1200) and `talk-400.jpg` (400×600) are the About photo,
  downscaled from `assets/img/talk.jpg` at the source 2:3 ratio (progressive JPEG, target under
  ~150 KB and ~45 KB). The About section pairs them with `about.portraitAlt`.
- `web/assets/masthead-cover.jpg` is the decorative masthead banner (1376×768, progressive JPEG,
  target under ~150 KB). It is a deep-forest pattern of the bugdroid-with-cuia mark; it is
  referenced by the top-level `coverImage` field in both JSON assets, using a path relative to the
  site root; `null` falls back to the CSS-only cover.
- Article covers are not stored in the repository: the Medium data source extracts the first
  usable image and rewrites Medium CDN URLs to
  `https://miro.medium.com/v2/resize:fit:480/format:webp/<asset>`. `Article.thumbnail` is that
  absolute URL, or `null` when the post has no usable image.
- `web/favicon.svg`, `web/favicon.ico`, and `web/assets/apple-touch-icon.png` share a tab-first
  bugdroid-with-cuia emblem on a forest rounded-square. The SVG is the source and is drawn for
  16 px legibility, not as a miniature of the masthead-cover mark; the ICO carries 16/32/48 px renders,
  and the touch icon is a full-bleed 180 px square. The icon links in `seo_head.dart` carry a
  `?v=` cache-buster — bump `_faviconVersion` whenever the artwork changes.
- Font licenses: SIL OFL 1.1; see `web/fonts/ATTRIBUTION.txt` and `web/fonts/OFL.txt`.
