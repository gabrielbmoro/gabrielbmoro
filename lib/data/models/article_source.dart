/// A publication whose articles the content page groups into a carousel.
///
/// The [id] is the stable key used by the carousels and by Medium feed
/// entries; the [label] is what readers see.
final class ArticleSource {
  const ArticleSource({required this.id, required this.label});

  final String id;
  final String label;

  /// Resolves the publication that owns an article from its canonical URL.
  ///
  /// The author profile feed mixes every publication, and the item link is the
  /// only thing that says which one it came from. Returns null for a link
  /// outside the publications the site lists.
  static ArticleSource? fromUrl(Uri url) {
    if (url.host == 'blog.insert-koin.io') {
      return koinDevelopersSource;
    }

    final isMediumHost = url.host == 'medium.com' || url.host.endsWith('.medium.com');
    if (isMediumHost && url.pathSegments.isNotEmpty && url.pathSegments.first == 'codandotv') {
      return codandoTvSource;
    }
    return null;
  }
}

const ArticleSource koinDevelopersSource = ArticleSource(
  id: 'koin-developers',
  label: 'Koin Developers',
);

const ArticleSource codandoTvSource = ArticleSource(
  id: 'codandotv',
  label: 'CodandoTV',
);
