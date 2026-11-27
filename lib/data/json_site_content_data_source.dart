import 'dart:convert';
import 'dart:io';

import 'package:gabriel_moro_site/data/site_content_data_source.dart';
import 'package:gabriel_moro_site/domain/models/site_content.dart';
import 'package:gabriel_moro_site/domain/models/site_links.dart';
import 'package:gabriel_moro_site/domain/site_paths.dart';

/// Reads the localized content assets from [contentDirectory].
///
/// Paths are resolved from the working directory, which is the repository
/// root for `jaspr serve` and `jaspr build`. Assets are discovered by name so
/// adding a locale only requires adding another JSON file. Every locale
/// declares its pages; this data source resolves the page routes and turns
/// them into page-relative links.
final class JsonSiteContentDataSource implements SiteContentDataSource {
  JsonSiteContentDataSource({this.contentDirectory = 'assets/content'});

  final String contentDirectory;

  @override
  SiteCatalog load() {
    final documents = _readDocuments();

    final links = _parseLinks(
      _object(documents.first.json['links'], '${documents.first.path}.links'),
      '${documents.first.path}.links',
    );

    for (final document in documents.skip(1)) {
      final candidate = _parseLinks(
        _object(document.json['links'], '${document.path}.links'),
        '${document.path}.links',
      );
      _ensureSharedLinks(links, candidate, documents.first.path, document.path);
    }

    final pagesByDocument = {
      for (final document in documents) document.path: _parsePages(document),
    };
    _ensureMatchingPages(documents, pagesByDocument);

    final ordered = _defaultFirst(documents);
    _ensureBilingual(ordered);

    final routesByDocument = <String, Map<PageId, String>>{
      for (final document in ordered)
        document.path: {
          for (final spec in pagesByDocument[document.path]!) spec.id: pageRoute(_localeRoute(document), spec.path),
        },
    };
    _ensureUniquePageRoutes(ordered, routesByDocument);

    final contents = <SiteContent>[];
    for (final document in ordered) {
      final routes = routesByDocument[document.path]!;
      contents.add(
        _parseContent(
          document,
          links,
          (id) => relativeHref(_localeRoute(document), routes[id]!),
        ),
      );
    }
    _ensureUniqueLocales(contents);

    final pages = <SitePage>[];
    for (var index = 0; index < ordered.length; index++) {
      final document = ordered[index];
      final content = contents[index];
      final specs = pagesByDocument[document.path]!;
      final routes = routesByDocument[document.path]!;
      final otherDocument = ordered[1 - index];
      final otherRoutes = routesByDocument[otherDocument.path]!;

      for (final spec in specs) {
        final route = routes[spec.id]!;

        pages.add(
          SitePage(
            content: content,
            id: spec.id,
            route: route,
            navLabel: spec.navLabel,
            summary: spec.summary,
            title: spec.title,
            description: spec.description,
            canonicalUrl: canonicalUrl(content.links.siteUrl, route),
            assetPrefix: relativeHref(route, '/'),
            homeHref: relativeHref(route, content.route),
            switchHref: relativeHref(route, otherRoutes[spec.id]!),
            nav: List.unmodifiable([
              for (final navSpec in specs)
                if (navSpec.navLabel case final label?)
                  NavItem(
                    id: navSpec.id,
                    label: label,
                    summary: navSpec.summary!,
                    href: relativeHref(route, routes[navSpec.id]!),
                    current: navSpec.id == spec.id,
                  ),
            ]),
            alternates: List.unmodifiable([
              for (var localeIndex = 0; localeIndex < ordered.length; localeIndex++)
                PageAlternate(
                  hrefLang: contents[localeIndex].lang,
                  url: canonicalUrl(
                    content.links.siteUrl,
                    routesByDocument[ordered[localeIndex].path]![spec.id]!,
                  ),
                ),
            ]),
          ),
        );
      }
    }

    return SiteCatalog(
      contents: List.unmodifiable(contents),
      pages: List.unmodifiable(pages),
    );
  }

  List<_ContentDocument> _readDocuments() {
    final directory = Directory(contentDirectory);
    if (!directory.existsSync()) {
      throw StateError(
        'Content directory not found: $contentDirectory. '
        'Run the build from the repository root.',
      );
    }

    final files = directory.listSync().whereType<File>().where((file) => file.path.endsWith('.json')).toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    if (files.isEmpty) {
      throw StateError('No content assets found in $contentDirectory.');
    }

    return [for (final file in files) _readDocument(file)];
  }

  _ContentDocument _readDocument(File file) {
    final String source;
    try {
      source = file.readAsStringSync(encoding: utf8);
    } on FileSystemException catch (error) {
      throw StateError('Could not read content asset ${file.path}: ${error.message}');
    }

    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object at the top level.');
      }
      return _ContentDocument(file.path, decoded);
    } on FormatException catch (error) {
      throw FormatException('Invalid JSON in ${file.path}: ${error.message}');
    }
  }

  SiteContent _parseContent(_ContentDocument document, SiteLinks links, String Function(PageId id) hrefFor) {
    final json = document.json;
    final path = document.path;

    return SiteContent(
      lang: _nonEmptyString(json, 'lang', path),
      route: _localeRoute(document),
      switchHrefLang: _string(json, 'switchHrefLang', path),
      switchLabel: _string(json, 'switchLabel', path),
      switchAriaLabel: _string(json, 'switchAriaLabel', path),
      skipLink: _string(json, 'skipLink', path),
      ogLocale: _string(json, 'ogLocale', path),
      ogImageAlt: _string(json, 'ogImageAlt', path),
      siteTitle: _string(json, 'siteTitle', path),
      tagline: _string(json, 'tagline', path),
      coverImage: _optionalString(json, 'coverImage', path),
      homeLabel: _string(json, 'homeLabel', path),
      navAriaLabel: _string(json, 'navAriaLabel', path),
      socialAriaLabel: _string(json, 'socialAriaLabel', path),
      navCta: _string(json, 'navCta', path),
      navCtaHref: _string(json, 'navCtaHref', path),
      mailto: _string(json, 'mailto', path),
      links: links,
      hero: _hero(_object(json['hero'], '$path.hero'), '$path.hero', hrefFor),
      about: _about(_object(json['about'], '$path.about'), '$path.about'),
      contentHub: _contentHub(_object(json['content'], '$path.content'), '$path.content'),
      experience: _experience(_object(json['experience'], '$path.experience'), '$path.experience'),
      toolkit: _toolkit(_object(json['toolkit'], '$path.toolkit'), '$path.toolkit'),
      work: _work(_object(json['work'], '$path.work'), '$path.work'),
      explore: _explore(_object(json['explore'], '$path.explore'), '$path.explore'),
      mentoring: _mentoring(_object(json['mentoring'], '$path.mentoring'), '$path.mentoring'),
      footer: _footer(_object(json['footer'], '$path.footer'), '$path.footer'),
    );
  }

  List<_PageSpec> _parsePages(_ContentDocument document) {
    final path = document.path;
    final specs = _mapList(
      document.json,
      'pages',
      path,
      (json, itemPath) => _PageSpec(
        id: _pageId(_string(json, 'id', itemPath), '$itemPath.id'),
        path: _string(json, 'path', itemPath),
        navLabel: _optionalString(json, 'navLabel', itemPath),
        summary: _optionalString(json, 'summary', itemPath),
        title: _nonEmptyString(json, 'title', itemPath),
        description: _nonEmptyString(json, 'description', itemPath),
      ),
    );

    if (specs.isEmpty || specs.first.id != PageId.home) {
      throw FormatException('$path.pages must start with the home page.');
    }

    final ids = <PageId>{};
    for (final spec in specs) {
      if (!ids.add(spec.id)) {
        throw FormatException('Duplicate page "${spec.id.name}" in $path.pages.');
      }
      if ((spec.id == PageId.home) != (spec.path.isEmpty)) {
        throw FormatException(
          'Only the home page may have an empty path in $path.pages '
          '("${spec.id.name}" has "${spec.path}").',
        );
      }
      if (spec.path.isNotEmpty && !_slugPattern.hasMatch(spec.path)) {
        throw FormatException(
          'Invalid page path "${spec.path}" for "${spec.id.name}" in $path.pages. '
          'Use lowercase letters, digits and dashes only.',
        );
      }
      if (spec.id == PageId.home && spec.navLabel != null) {
        throw FormatException('The home page must not appear in the tab bar in $path.pages.');
      }
      if (spec.navLabel != null) {
        if (spec.navLabel!.isEmpty) {
          throw FormatException('Page "${spec.id.name}" has an empty navLabel in $path.pages.');
        }
        if (spec.summary == null || spec.summary!.isEmpty) {
          throw FormatException(
            'Page "${spec.id.name}" is in the tab bar, so $path.pages needs a non-empty summary.',
          );
        }
      }
    }

    return specs;
  }

  void _ensureMatchingPages(List<_ContentDocument> documents, Map<String, List<_PageSpec>> pagesByDocument) {
    final reference = pagesByDocument[documents.first.path]!;

    for (final document in documents.skip(1)) {
      final candidate = pagesByDocument[document.path]!;

      final sameOrder =
          candidate.length == reference.length &&
          Iterable.generate(reference.length).every((index) => candidate[index].id == reference[index].id);
      if (!sameOrder) {
        throw FormatException(
          'Content assets must declare the same pages in the same order: '
          '${documents.first.path} has ${reference.map((page) => page.id.name).join(', ')}, '
          '${document.path} has ${candidate.map((page) => page.id.name).join(', ')}.',
        );
      }

      for (var index = 0; index < reference.length; index++) {
        if ((reference[index].navLabel == null) != (candidate[index].navLabel == null)) {
          throw FormatException(
            'Page "${reference[index].id.name}" must be in the tab bar in every locale '
            'or in none: ${documents.first.path} and ${document.path} disagree.',
          );
        }
      }
    }
  }

  List<_ContentDocument> _defaultFirst(List<_ContentDocument> documents) {
    for (final document in documents) {
      final route = _localeRoute(document);
      if (route != '/' && !_localeRoutePattern.hasMatch(route)) {
        throw FormatException(
          'Invalid locale route "$route" in ${document.path}. '
          'Use "/" or a single path segment such as "/en".',
        );
      }
    }

    final roots = [
      for (final document in documents)
        if (_localeRoute(document) == '/') document,
    ];

    if (roots.length != 1) {
      throw FormatException(
        'Expected exactly one locale at route "/", found ${roots.length}. '
        'The site root serves the default locale.',
      );
    }

    final root = roots.single;
    return [
      root,
      for (final document in documents)
        if (document != root) document,
    ];
  }

  /// The locale switch and the `hreflang` alternates point at the other
  /// locale, so the assets must publish exactly two languages.
  void _ensureBilingual(List<_ContentDocument> documents) {
    if (documents.length != 2) {
      throw FormatException(
        'Expected exactly two locales in $contentDirectory, found ${documents.length}. '
        'The locale switch points at the other locale.',
      );
    }
  }

  void _ensureUniquePageRoutes(
    List<_ContentDocument> documents,
    Map<String, Map<PageId, String>> routesByDocument,
  ) {
    final routes = <String>{};
    for (final document in documents) {
      for (final route in routesByDocument[document.path]!.values) {
        if (!routes.add(route)) {
          throw FormatException('Duplicate page route "$route" in $contentDirectory.');
        }
      }
    }
  }

  void _ensureUniqueLocales(List<SiteContent> contents) {
    final langs = <String>{};
    final routes = <String>{};

    for (final content in contents) {
      if (!langs.add(content.lang)) {
        throw FormatException('Duplicate locale "${content.lang}" in $contentDirectory.');
      }
      if (!routes.add(content.route)) {
        throw FormatException('Duplicate locale route "${content.route}" in $contentDirectory.');
      }
    }
  }

  SiteLinks _parseLinks(Map<String, dynamic> json, String path) => SiteLinks(
    siteUrl: _string(json, 'siteUrl', path),
    email: _string(json, 'email', path),
    linkedInUrl: _string(json, 'linkedInUrl', path),
    gitHubUrl: _string(json, 'gitHubUrl', path),
    mediumUrl: _string(json, 'mediumUrl', path),
    youTubeUrl: _string(json, 'youTubeUrl', path),
    codandoTvUrl: _string(json, 'codandoTvUrl', path),
    koinChampionUrl: _string(json, 'koinChampionUrl', path),
  );

  HeroContent _hero(Map<String, dynamic> json, String path, String Function(PageId id) hrefFor) => HeroContent(
    kicker: _string(json, 'kicker', path),
    availability: _string(json, 'availability', path),
    availabilityNote: _string(json, 'availabilityNote', path),
    lede: _string(json, 'lede', path),
    primaryCta: _string(json, 'primaryCta', path),
    primaryCtaHref: hrefFor(_pageId(_string(json, 'primaryCtaPage', path), '$path.primaryCtaPage')),
    secondaryCta: _string(json, 'secondaryCta', path),
    secondaryCtaHref: hrefFor(_pageId(_string(json, 'secondaryCtaPage', path), '$path.secondaryCtaPage')),
    note: _string(json, 'note', path),
    stats: _mapList(
      json,
      'stats',
      path,
      (stat, statPath) => HeroStat(
        _string(stat, 'value', statPath),
        _string(stat, 'label', statPath),
      ),
    ),
  );

  AboutContent _about(Map<String, dynamic> json, String path) => AboutContent(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    intro: _string(json, 'intro', path),
    sections: _mapList(
      json,
      'sections',
      path,
      (section, sectionPath) => AboutTopic(
        title: _string(section, 'title', sectionPath),
        paragraphs: _strings(section, 'paragraphs', sectionPath),
      ),
    ),
    currentlyLabel: _string(json, 'currentlyLabel', path),
    currentRoles: _mapList(
      json,
      'currentRoles',
      path,
      (role, rolePath) => CurrentRole(
        role: _string(role, 'role', rolePath),
        company: _string(role, 'company', rolePath),
        period: _string(role, 'period', rolePath),
        url: _optionalString(role, 'url', rolePath),
      ),
    ),
    contactLabel: _string(json, 'contactLabel', path),
    contactText: _string(json, 'contactText', path),
    portraitAlt: _string(json, 'portraitAlt', path),
    portraitRole: _string(json, 'portraitRole', path),
    educationConnector: _string(json, 'educationConnector', path),
    education: _mapList(
      json,
      'education',
      path,
      (entry, entryPath) => EducationEntry(
        degree: _string(entry, 'degree', entryPath),
        institution: _string(entry, 'institution', entryPath),
        url: _string(entry, 'url', entryPath),
      ),
    ),
  );

  ContentHub _contentHub(Map<String, dynamic> json, String path) => ContentHub(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    lede: _string(json, 'lede', path),
    latestTitle: _string(json, 'latestTitle', path),
    articles: _mapList(
      json,
      'articles',
      path,
      (article, articlePath) => Article(
        title: _string(article, 'title', articlePath),
        publication: _string(article, 'publication', articlePath),
        published: _string(article, 'published', articlePath),
        url: _string(article, 'url', articlePath),
        thumbnail: _optionalString(article, 'thumbnail', articlePath),
      ),
    ),
    allArticlesLabel: _string(json, 'allArticlesLabel', path),
    allArticlesHref: _string(json, 'allArticlesHref', path),
    channelsTitle: _string(json, 'channelsTitle', path),
    channels: _mapList(
      json,
      'channels',
      path,
      (channel, channelPath) => ContentChannel(
        label: _string(channel, 'label', channelPath),
        description: _string(channel, 'description', channelPath),
        links: _linkRefs(channel, channelPath),
      ),
    ),
    topicsTitle: _string(json, 'topicsTitle', path),
    topics: _strings(json, 'topics', path),
    recognition: _recognition(_object(json['recognition'], '$path.recognition'), '$path.recognition'),
    ctaTitle: _string(json, 'ctaTitle', path),
    ctaText: _string(json, 'ctaText', path),
    ctaButton: _string(json, 'ctaButton', path),
    ctaHref: _string(json, 'ctaHref', path),
  );

  ContentRecognition _recognition(Map<String, dynamic> json, String path) => ContentRecognition(
    label: _string(json, 'label', path),
    description: _string(json, 'description', path),
    linkLabel: _string(json, 'linkLabel', path),
    url: _string(json, 'url', path),
  );

  ExperienceContent _experience(Map<String, dynamic> json, String path) => ExperienceContent(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    lede: _string(json, 'lede', path),
    roles: _mapList(
      json,
      'roles',
      path,
      (role, rolePath) => Role(
        company: _string(role, 'company', rolePath),
        title: _string(role, 'title', rolePath),
        period: _string(role, 'period', rolePath),
        bullets: _strings(role, 'bullets', rolePath),
      ),
    ),
    linkLabel: _string(json, 'linkLabel', path),
  );

  ToolkitContent _toolkit(Map<String, dynamic> json, String path) => ToolkitContent(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    groups: _mapList(
      json,
      'groups',
      path,
      (group, groupPath) => SkillGroup(
        _string(group, 'label', groupPath),
        _string(group, 'value', groupPath),
      ),
    ),
  );

  WorkContent _work(Map<String, dynamic> json, String path) => WorkContent(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    lede: _string(json, 'lede', path),
    projects: _mapList(
      json,
      'projects',
      path,
      (project, projectPath) => Project(
        name: _string(project, 'name', projectPath),
        description: _string(project, 'description', projectPath),
        tags: _strings(project, 'tags', projectPath),
        url: _string(project, 'url', projectPath),
        linkLabel: _string(project, 'linkLabel', projectPath),
      ),
    ),
  );

  ExploreContent _explore(Map<String, dynamic> json, String path) => ExploreContent(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    lede: _string(json, 'lede', path),
  );

  MentoringContent _mentoring(Map<String, dynamic> json, String path) => MentoringContent(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    lede: _string(json, 'lede', path),
    availability: _string(json, 'availability', path),
    availabilityNote: _string(json, 'availabilityNote', path),
    primaryCta: _string(json, 'primaryCta', path),
    primaryCtaHref: _string(json, 'primaryCtaHref', path),
    ctaNote: _string(json, 'ctaNote', path),
    audienceTitle: _string(json, 'audienceTitle', path),
    audience: _strings(json, 'audience', path),
    topicsTitle: _string(json, 'topicsTitle', path),
    topics: _mapList(
      json,
      'topics',
      path,
      (topic, topicPath) => MentoringTopic(
        label: _string(topic, 'label', topicPath),
        description: _string(topic, 'description', topicPath),
      ),
    ),
    stepsTitle: _string(json, 'stepsTitle', path),
    steps: _mapList(
      json,
      'steps',
      path,
      (step, stepPath) => MentoringStep(
        title: _string(step, 'title', stepPath),
        description: _string(step, 'description', stepPath),
      ),
    ),
    outcomesTitle: _string(json, 'outcomesTitle', path),
    outcomes: _strings(json, 'outcomes', path),
    closingTitle: _string(json, 'closingTitle', path),
    closingText: _string(json, 'closingText', path),
    closingCta: _string(json, 'closingCta', path),
    closingHref: _string(json, 'closingHref', path),
  );

  FooterContent _footer(Map<String, dynamic> json, String path) => FooterContent(
    heading: _string(json, 'heading', path),
    text: _string(json, 'text', path),
    cta: _string(json, 'cta', path),
    availability: _string(json, 'availability', path),
    copyright: _string(json, 'copyright', path),
    builtWith: _string(json, 'builtWith', path),
    links: _linkRefs(json, path),
  );

  List<LinkRef> _linkRefs(Map<String, dynamic> json, String path) => _mapList(
    json,
    'links',
    path,
    (link, linkPath) => LinkRef(
      _string(link, 'label', linkPath),
      _string(link, 'url', linkPath),
    ),
  );

  void _ensureSharedLinks(SiteLinks expected, SiteLinks actual, String expectedPath, String actualPath) {
    final differences = [
      if (expected.siteUrl != actual.siteUrl) 'siteUrl',
      if (expected.email != actual.email) 'email',
      if (expected.linkedInUrl != actual.linkedInUrl) 'linkedInUrl',
      if (expected.gitHubUrl != actual.gitHubUrl) 'gitHubUrl',
      if (expected.mediumUrl != actual.mediumUrl) 'mediumUrl',
      if (expected.youTubeUrl != actual.youTubeUrl) 'youTubeUrl',
      if (expected.codandoTvUrl != actual.codandoTvUrl) 'codandoTvUrl',
      if (expected.koinChampionUrl != actual.koinChampionUrl) 'koinChampionUrl',
    ];

    if (differences.isNotEmpty) {
      throw FormatException(
        'Shared links differ between $expectedPath and $actualPath: ${differences.join(', ')}. '
        'Keep the "links" block identical across content assets.',
      );
    }
  }
}

final _slugPattern = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
final _localeRoutePattern = RegExp(r'^/[a-z0-9]+(?:-[a-z0-9]+)*$');

String _localeRoute(_ContentDocument document) => _nonEmptyString(document.json, 'route', document.path);

PageId _pageId(String value, String path) {
  for (final id in PageId.values) {
    if (id.name == value) {
      return id;
    }
  }
  throw FormatException(
    'Unknown page "$value" at $path. '
    'Expected one of: ${PageId.values.map((id) => id.name).join(', ')}.',
  );
}

final class _ContentDocument {
  const _ContentDocument(this.path, this.json);

  final String path;
  final Map<String, dynamic> json;
}

final class _PageSpec {
  const _PageSpec({
    required this.id,
    required this.path,
    required this.navLabel,
    required this.summary,
    required this.title,
    required this.description,
  });

  final PageId id;
  final String path;
  final String? navLabel;
  final String? summary;
  final String title;
  final String description;
}

Map<String, dynamic> _object(Object? value, String path) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  throw FormatException('Expected an object at $path.');
}

List<dynamic> _array(Object? value, String path) {
  if (value is List<dynamic>) {
    return value;
  }
  throw FormatException('Expected an array at $path.');
}

String _string(Map<String, dynamic> json, String key, String path) => _asString(json[key], '$path.$key');

String? _optionalString(Map<String, dynamic> json, String key, String path) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  return _asString(value, '$path.$key');
}

String _nonEmptyString(Map<String, dynamic> json, String key, String path) {
  final value = _string(json, key, path);
  if (value.isEmpty) {
    throw FormatException('Expected a non-empty string at $path.$key.');
  }
  return value;
}

String _asString(Object? value, String path) {
  if (value is String) {
    return value;
  }
  throw FormatException('Expected a string at $path.');
}

List<String> _strings(Map<String, dynamic> json, String key, String path) {
  final values = _array(json[key], '$path.$key');
  return [
    for (var index = 0; index < values.length; index++) _asString(values[index], '$path.$key[$index]'),
  ];
}

List<T> _mapList<T>(
  Map<String, dynamic> json,
  String key,
  String path,
  T Function(Map<String, dynamic> json, String path) parse,
) {
  final values = _array(json[key], '$path.$key');
  return [
    for (var index = 0; index < values.length; index++)
      parse(
        _object(values[index], '$path.$key[$index]'),
        '$path.$key[$index]',
      ),
  ];
}
