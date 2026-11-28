import 'package:gabriel_moro_site/domain/site_paths.dart';
import 'package:test/test.dart';

void main() {
  test('relativeHref keeps the links page-relative', () {
    expect(SitePaths.relativeHref('/', '/'), './');
    expect(SitePaths.relativeHref('/', '/sobre'), 'sobre/');
    expect(SitePaths.relativeHref('/conteudo', '/en/content'), '../en/content/');
    expect(SitePaths.relativeHref('/en/content', '/'), '../../');
  });

  test('canonicalUrl normalizes the site URL and the route', () {
    expect(SitePaths.canonicalUrl('https://gabrielbmoro.dev', '/'), 'https://gabrielbmoro.dev/');
    expect(
      SitePaths.canonicalUrl('https://gabrielbmoro.dev/', '/en/content'),
      'https://gabrielbmoro.dev/en/content/',
    );
  });

  test('pageRoute joins the locale root and the page path', () {
    expect(SitePaths.pageRoute('/', ''), '/');
    expect(SitePaths.pageRoute('/', 'sobre'), '/sobre');
    expect(SitePaths.pageRoute('/en', 'content'), '/en/content');
  });
}
