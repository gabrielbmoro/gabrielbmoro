import 'package:gabriel_moro_site/domain/models/site_content.dart';

/// The localized copy plus every routable page built from it.
final class SiteCatalog {
  const SiteCatalog({required this.contents, required this.pages});

  /// Every published locale, default locale first.
  final List<SiteContent> contents;

  /// Every page of every locale, default locale first.
  final List<SitePage> pages;
}
