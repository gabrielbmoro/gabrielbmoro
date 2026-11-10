import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:gabriel_moro_site/domain/models/site_content.dart';

/// Bump this when the favicon artwork changes: browsers and GitHub Pages cache
/// tab icons aggressively, even across a redeploy.
const _faviconVersion = '2';

/// Per-route document metadata and head assets.
///
/// Asset URLs are page-relative so the site works both at the root during
/// local development and under the repository path on GitHub Pages.
class SeoHead extends StatelessComponent {
  const SeoHead({required this.content, required this.locales, super.key});

  final SiteContent content;

  /// Every published locale, in site order; the first one is the default
  /// (the locale served at the site root).
  final List<SiteContent> locales;

  @override
  Component build(BuildContext context) {
    final siteUrl = content.links.siteUrl;
    final image = '${siteUrl}assets/avatar-800.jpg';
    final c = content;

    return Document.head(
      title: c.metaTitle,
      meta: {'description': c.metaDescription},
      children: [
        link(rel: 'stylesheet', href: '${c.assetPrefix}site.css'),
        link(
          rel: 'icon',
          href: '${c.assetPrefix}favicon.svg?v=$_faviconVersion',
          type: 'image/svg+xml',
          attributes: const {'sizes': 'any'},
        ),
        link(
          rel: 'icon',
          href: '${c.assetPrefix}favicon.ico?v=$_faviconVersion',
          type: 'image/x-icon',
          attributes: const {'sizes': '16x16 32x32 48x48'},
        ),
        link(
          rel: 'apple-touch-icon',
          href: '${c.assetPrefix}assets/apple-touch-icon.png?v=$_faviconVersion',
          attributes: const {'sizes': '180x180'},
        ),
        link(
          rel: 'preload',
          href: '${c.assetPrefix}fonts/inter-latin.woff2',
          attributes: const {'as': 'font', 'type': 'font/woff2', 'crossorigin': 'anonymous'},
        ),
        link(
          rel: 'preload',
          href: '${c.assetPrefix}fonts/bricolage-grotesque-latin.woff2',
          attributes: const {'as': 'font', 'type': 'font/woff2', 'crossorigin': 'anonymous'},
        ),
        if (c.coverImage case final cover?)
          link(
            rel: 'preload',
            href: '${c.assetPrefix}$cover',
            attributes: const {'as': 'image', 'fetchpriority': 'high'},
          ),
        link(rel: 'canonical', href: c.canonicalUrl),
        for (final locale in locales)
          link(rel: 'alternate', href: locale.canonicalUrl, attributes: {'hreflang': locale.lang}),
        link(rel: 'alternate', href: locales.first.canonicalUrl, attributes: const {'hreflang': 'x-default'}),
        meta(content: c.metaTitle, attributes: const {'property': 'og:title'}),
        meta(content: c.metaDescription, attributes: const {'property': 'og:description'}),
        meta(content: c.canonicalUrl, attributes: const {'property': 'og:url'}),
        meta(content: 'website', attributes: const {'property': 'og:type'}),
        meta(content: c.siteTitle, attributes: const {'property': 'og:site_name'}),
        meta(content: c.ogLocale, attributes: const {'property': 'og:locale'}),
        meta(content: image, attributes: const {'property': 'og:image'}),
        meta(content: '800', attributes: const {'property': 'og:image:width'}),
        meta(content: '800', attributes: const {'property': 'og:image:height'}),
        meta(content: c.ogImageAlt, attributes: const {'property': 'og:image:alt'}),
        meta(content: 'summary', attributes: const {'name': 'twitter:card'}),
        meta(content: c.metaTitle, attributes: const {'name': 'twitter:title'}),
        meta(content: c.metaDescription, attributes: const {'name': 'twitter:description'}),
        meta(content: image, attributes: const {'name': 'twitter:image'}),
      ],
    );
  }
}
