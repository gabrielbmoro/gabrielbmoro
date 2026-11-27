import 'package:gabriel_moro_site/domain/models/site_content.dart';

/// Provides the localized content the site renders.
///
/// Implementations live in the data layer; widgets only depend on this
/// abstraction.
abstract interface class SiteContentRepository {
  /// Every locale the site publishes, in router order.
  ///
  /// The default locale comes first, because that is the language a visitor
  /// gets at the site root and the `x-default` target.
  List<SiteContent> get contents;

  /// Every page of every locale, with links already resolved per route.
  ///
  /// The default locale's pages come first and each page's home comes first.
  List<SitePage> get pages;

  /// The locale served at the site root (`/`).
  SiteContent get defaultContent;

  /// The page served at the site root (`/`).
  SitePage get defaultPage;

  /// Content for a locale tag such as `en` or `pt-BR`.
  ///
  /// Throws an [ArgumentError] when [lang] is not published.
  SiteContent contentFor(String lang);
}
