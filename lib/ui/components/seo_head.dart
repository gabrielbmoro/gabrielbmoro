import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../../domain/models/site_content.dart';

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
        link(rel: 'icon', href: '${c.assetPrefix}favicon.svg', type: 'image/svg+xml'),
        link(rel: 'icon', href: '${c.assetPrefix}favicon.ico', type: 'image/x-icon'),
        link(rel: 'apple-touch-icon', href: '${c.assetPrefix}assets/apple-touch-icon.png'),
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
        link(rel: 'canonical', href: c.canonicalUrl),
        for (final locale in locales)
          link(rel: 'alternate', href: locale.canonicalUrl, attributes: {'hreflang': locale.lang}),
        link(rel: 'alternate', href: locales.first.canonicalUrl, attributes: const {'hreflang': 'x-default'}),
        meta(content: c.metaTitle, attributes: const {'property': 'og:title'}),
        meta(content: c.metaDescription, attributes: const {'property': 'og:description'}),
        meta(content: c.canonicalUrl, attributes: const {'property': 'og:url'}),
        meta(content: 'website', attributes: const {'property': 'og:type'}),
        meta(content: 'Gabriel Moro', attributes: const {'property': 'og:site_name'}),
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
