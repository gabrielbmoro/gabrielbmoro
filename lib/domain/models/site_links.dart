/// Canonical URLs and contact details shared by every locale.
///
/// The `links` block is duplicated in each content asset so the locale files
/// stay self-contained; the data source rejects mismatches and shares one
/// instance with every content object, so the site only ever reads these
/// values once.
library;

class SiteLinks {
  const SiteLinks({
    required this.siteUrl,
    required this.email,
    required this.linkedInUrl,
    required this.gitHubUrl,
    required this.mediumUrl,
    required this.youTubeUrl,
    required this.codandoTvUrl,
    required this.koinChampionUrl,
  });

  final String siteUrl;
  final String email;
  final String linkedInUrl;
  final String gitHubUrl;
  final String mediumUrl;
  final String youTubeUrl;
  final String codandoTvUrl;
  final String koinChampionUrl;
}
