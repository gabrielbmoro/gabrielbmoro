import 'package:gabriel_moro_site/data/json_site_content_data_source.dart';
import 'package:test/test.dart';

void main() {
  test('loads only the content copy and leaves the article list to the repository', () {
    final catalog = JsonSiteContentDataSource().load();

    expect(catalog.contents, hasLength(2));
    for (final content in catalog.contents) {
      expect(content.contentHub.articleMonths, hasLength(12));
      expect(content.contentHub.articles, isEmpty);
      expect(content.contentHub.filterAllLabel, isNotEmpty);
      expect(content.contentHub.filterAriaLabel, isNotEmpty);
    }
  });
}
