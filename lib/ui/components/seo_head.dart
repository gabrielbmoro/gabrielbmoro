import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:gabriel_moro_site/domain/models/site_content.dart';

/// Bump this when the favicon artwork changes: browsers and GitHub Pages cache
/// tab icons aggressively, even across a redeploy.
const _faviconVersion = '2';

/// Per-page document metadata and head assets.
///
/// Asset URLs are page-relative so the site works both at the root during
/// local development and under the repository path on GitHub Pages.
class SeoHead extends StatelessComponent {
  const SeoHead({required this.page, super.key});

  final SitePage page;

  @override
  Component build(BuildContext context) {
    final content = page.content;
    final image = '${content.links.siteUrl}assets/avatar-800.jpg';

    return Document.head(
      title: page.title,
      meta: {'description': page.description},
      children: [
        link(rel: 'stylesheet', href: '${page.assetPrefix}site.css'),
        link(
          rel: 'icon',
          href: '${page.assetPrefix}favicon.svg?v=$_faviconVersion',
          type: 'image/svg+xml',
          attributes: const {'sizes': 'any'},
        ),
        link(
          rel: 'icon',
          href: '${page.assetPrefix}favicon.ico?v=$_faviconVersion',
          type: 'image/x-icon',
          attributes: const {'sizes': '16x16 32x32 48x48'},
        ),
        link(
          rel: 'apple-touch-icon',
          href: '${page.assetPrefix}assets/apple-touch-icon.png?v=$_faviconVersion',
          attributes: const {'sizes': '180x180'},
        ),
        link(
          rel: 'preload',
          href: '${page.assetPrefix}fonts/inter-latin.woff2',
          attributes: const {'as': 'font', 'type': 'font/woff2', 'crossorigin': 'anonymous'},
        ),
        link(
          rel: 'preload',
          href: '${page.assetPrefix}fonts/montaga-latin.woff2',
          attributes: const {'as': 'font', 'type': 'font/woff2', 'crossorigin': 'anonymous'},
        ),
        if (content.coverImage case final cover?)
          link(
            rel: 'preload',
            href: '${page.assetPrefix}$cover',
            attributes: const {'as': 'image', 'fetchpriority': 'high'},
          ),
        link(rel: 'canonical', href: page.canonicalUrl),
        for (final alternate in page.alternates)
          link(rel: 'alternate', href: alternate.url, attributes: {'hreflang': alternate.hrefLang}),
        link(
          rel: 'alternate',
          href: page.alternates.first.url,
          attributes: const {'hreflang': 'x-default'},
        ),
        meta(content: page.title, attributes: const {'property': 'og:title'}),
        meta(content: page.description, attributes: const {'property': 'og:description'}),
        meta(content: page.canonicalUrl, attributes: const {'property': 'og:url'}),
        meta(content: 'website', attributes: const {'property': 'og:type'}),
        meta(content: content.siteTitle, attributes: const {'property': 'og:site_name'}),
        meta(content: content.ogLocale, attributes: const {'property': 'og:locale'}),
        meta(content: image, attributes: const {'property': 'og:image'}),
        meta(content: '800', attributes: const {'property': 'og:image:width'}),
        meta(content: '800', attributes: const {'property': 'og:image:height'}),
        meta(content: content.ogImageAlt, attributes: const {'property': 'og:image:alt'}),
        meta(content: 'summary', attributes: const {'name': 'twitter:card'}),
        meta(content: page.title, attributes: const {'name': 'twitter:title'}),
        meta(content: page.description, attributes: const {'name': 'twitter:description'}),
        meta(content: image, attributes: const {'name': 'twitter:image'}),
      ],
    );
  }
}
