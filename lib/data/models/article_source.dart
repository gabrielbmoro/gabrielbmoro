/// A publication the articles page can filter by.
///
/// The [id] is the stable key used by the CSS filter and by Medium feed
/// entries; the [label] is what readers see. Keep the ids in sync with the
/// static filter rules in `web/site.css`.
final class ArticleSource {
  const ArticleSource({required this.id, required this.label});

  final String id;
  final String label;
}

const ArticleSource koinDevelopersSource = ArticleSource(
  id: 'koin-developers',
  label: 'Koin Developers',
);

const ArticleSource codandoTvSource = ArticleSource(
  id: 'codandotv',
  label: 'CodandoTV',
);
