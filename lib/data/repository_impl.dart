import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/domain/repository.dart';
import 'package:gabriel_moro_site/data/site_content_data_source.dart';

/// Content repository backed by the localized assets.
final class SiteContentRepositoryImpl implements SiteContentRepository {
  SiteContentRepositoryImpl(SiteContentDataSource dataSource)
    : _contents = List.unmodifiable(_withDefaultFirst(dataSource.load()));

  final List<SiteContent> _contents;

  @override
  List<SiteContent> get contents => _contents;

  @override
  SiteContent get defaultContent => _contents.first;

  @override
  SiteContent contentFor(String lang) => _contents.firstWhere(
    (content) => content.lang == lang,
    orElse: () => throw ArgumentError.value(lang, 'lang', 'Unknown site locale'),
  );

  /// Puts the locale published at `/` first so `contents.first` is the default.
  static List<SiteContent> _withDefaultFirst(List<SiteContent> contents) {
    final roots = [
      for (final content in contents)
        if (content.route == '/') content,
    ];
    if (roots.length != 1) {
      throw FormatException(
        'Expected exactly one locale at route "/", found ${roots.length}. '
        'The site root serves the default locale.',
      );
    }
    final root = roots.single;
    return [
      root,
      for (final content in contents)
        if (content != root) content,
    ];
  }
}
