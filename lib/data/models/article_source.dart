/// A publication whose articles the content page groups into a carousel.
///
/// The [id] is the stable key used by the carousels and by Medium feed
/// entries; the [label] is what readers see.
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
