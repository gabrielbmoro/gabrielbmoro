import 'package:get_it/get_it.dart';

import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:gabriel_moro_site/data/repository_impl.dart';
import 'package:gabriel_moro_site/data/site_content_data_source.dart';
import 'package:gabriel_moro_site/domain/repository.dart';

/// Global service locator used by the composition root.
final getIt = GetIt.instance;

/// Registers the app's dependencies. Call once from `main`.
void configureDependencies() {
  getIt
    ..registerLazySingleton<SiteContentDataSource>(() => JsonSiteContentDataSource())
    ..registerLazySingleton<SiteContentRepository>(
      () => SiteContentRepositoryImpl(getIt<SiteContentDataSource>()),
    );
}
