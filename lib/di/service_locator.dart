import 'package:get_it/get_it.dart';

import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:gabriel_moro_site/data/medium_article_source.dart';
import 'package:gabriel_moro_site/data/repository_impl.dart';
import 'package:gabriel_moro_site/data/youtube_video_source.dart';
import 'package:gabriel_moro_site/domain/repository.dart';

/// Global service locator used by the composition root.
final getIt = GetIt.instance;

/// Registers the app's dependencies. Call once from `main`.
///
/// The three concrete data sources are independent. The repository loads the
/// JSON content and the two feeds at build time, attaches the articles and
/// videos to the content, and the composition root awaits it before rendering.
Future<void> configureDependencies() async {
  final contentDataSource = JsonSiteContentDataSource();
  final mediumArticleDataSource = MediumArticleSource();
  final youTubeVideoDataSource = YouTubeVideoSource();
  final repository = await SiteContentRepositoryImpl.load(
    content: contentDataSource,
    mediumArticles: mediumArticleDataSource,
    youTubeVideos: youTubeVideoDataSource,
  );

  getIt
    ..registerSingleton<JsonSiteContentDataSource>(contentDataSource)
    ..registerSingleton<MediumArticleSource>(mediumArticleDataSource)
    ..registerSingleton<YouTubeVideoSource>(youTubeVideoDataSource)
    ..registerSingleton<SiteContentRepository>(repository);
}
