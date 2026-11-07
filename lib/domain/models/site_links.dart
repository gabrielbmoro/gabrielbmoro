/// Canonical URLs and contact details shared by every locale.
///
/// Page copy, footer/community links, SEO alternates and structured data all
/// read from the same [SiteLinks] instance, so a domain or handle change only
/// has to happen once.
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
