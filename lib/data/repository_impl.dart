import '../domain/models/site_content.dart';
import '../domain/repository.dart';
import 'site_content_data_source.dart';

/// Content repository backed by the localized assets.
final class SiteContentRepositoryImpl implements SiteContentRepository {
  SiteContentRepositoryImpl(SiteContentDataSource dataSource) : _contents = List.unmodifiable(dataSource.load());

  final List<SiteContent> _contents;

  @override
  List<SiteContent> get contents => _contents;

  @override
  SiteContent contentFor(String lang) => _contents.firstWhere(
    (content) => content.lang == lang,
    orElse: () => throw ArgumentError.value(lang, 'lang', 'Unknown site locale'),
  );
}
