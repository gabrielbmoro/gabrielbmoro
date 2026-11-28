/// Helpers for the page-relative links the static site ships.
///
/// A route is a site-root path such as `/`, `/sobre` or `/en/about`, written
/// without a trailing slash. Each route is published as `<route>/index.html`,
/// so links are resolved from the page's directory.
library;

/// Route math for the page-relative links and canonical URLs the site publishes.
abstract final class SitePaths {
  /// Returns the href that, from the page at [fromRoute], points at [toRoute].
  ///
  /// The link is always page-relative, so the site works both at the domain root
  /// and when served from a sub-directory, without a `<base>` element.
  static String relativeHref(String fromRoute, String toRoute) {
    final from = _segments(fromRoute);
    final to = _segments(toRoute);

    var common = 0;
    while (common < from.length && common < to.length && from[common] == to[common]) {
      common++;
    }

    final parts = [
      for (var index = common; index < from.length; index++) '..',
      ...to.skip(common),
    ];

    return parts.isEmpty ? './' : '${parts.join('/')}/';
  }

  /// Returns the canonical URL of [route] under [siteUrl], with a trailing slash
  /// so it matches the directory GitHub Pages publishes.
  static String canonicalUrl(String siteUrl, String route) {
    final base = siteUrl.endsWith('/') ? siteUrl : '$siteUrl/';
    final segments = _segments(route);
    if (segments.isEmpty) {
      return base;
    }
    return '$base${segments.join('/')}/';
  }

  /// Joins a locale root route with a page path (`''` is the locale home).
  static String pageRoute(String localeRoute, String path) {
    if (path.isEmpty) {
      return localeRoute;
    }
    final base = localeRoute == '/' ? '' : localeRoute;
    return '$base/$path';
  }

  static List<String> _segments(String route) => [
    for (final segment in route.split('/'))
      if (segment.isNotEmpty) segment,
  ];
}
