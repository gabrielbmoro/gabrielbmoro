import 'package:gabriel_moro_site/data/site_content_data_source.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/domain/repository.dart';

/// Content repository backed by the localized assets.
final class SiteContentRepositoryImpl implements SiteContentRepository {
  SiteContentRepositoryImpl(SiteContentDataSource dataSource) : _catalog = dataSource.load();

  final SiteCatalog _catalog;

  @override
  List<SiteContent> get contents => _catalog.contents;

  @override
  List<SitePage> get pages => _catalog.pages;

  @override
  SiteContent get defaultContent => _catalog.contents.first;

  @override
  SitePage get defaultPage => _catalog.pages.first;

  @override
  SiteContent contentFor(String lang) => _catalog.contents.firstWhere(
    (content) => content.lang == lang,
    orElse: () => throw ArgumentError.value(lang, 'lang', 'Unknown site locale'),
  );
}
