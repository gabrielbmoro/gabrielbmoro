import 'package:get_it/get_it.dart';

import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:gabriel_moro_site/data/medium_article_source.dart';
import 'package:gabriel_moro_site/data/repository_impl.dart';
import 'package:gabriel_moro_site/domain/repository.dart';

/// Global service locator used by the composition root.
final getIt = GetIt.instance;

/// Registers the app's dependencies. Call once from `main`.
///
/// The two concrete data sources are independent. The repository loads both at
/// build time, attaches the Medium articles to the content, and the
/// composition root awaits it before rendering.
Future<void> configureDependencies() async {
  final contentDataSource = JsonSiteContentDataSource();
  final mediumArticleDataSource = MediumArticleSource();
  final repository = await SiteContentRepositoryImpl.load(
    content: contentDataSource,
    mediumArticles: mediumArticleDataSource,
  );

  getIt
    ..registerSingleton<JsonSiteContentDataSource>(contentDataSource)
    ..registerSingleton<MediumArticleSource>(mediumArticleDataSource)
    ..registerSingleton<SiteContentRepository>(repository);
}
