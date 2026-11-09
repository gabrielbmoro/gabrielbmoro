import 'package:gabriel_moro_site/domain/models/site_content.dart';

/// Supplies the localized content the repository exposes.
///
/// Implementations live in the data layer and may read from files, embedded
/// assets or any other source.
abstract interface class SiteContentDataSource {
  /// Every locale the site publishes, in router order.
  List<SiteContent> load();
}
