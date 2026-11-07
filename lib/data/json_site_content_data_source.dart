import 'dart:convert';
import 'dart:io';

import '../domain/models/site_content.dart';
import '../domain/models/site_links.dart';
import 'site_content_data_source.dart';

/// Reads the localized content assets from [contentDirectory].
///
/// Paths are resolved from the working directory, which is the repository
/// root for `jaspr serve` and `jaspr build`. Assets are discovered by name so
/// adding a locale only requires adding another JSON file.
final class JsonSiteContentDataSource implements SiteContentDataSource {
  JsonSiteContentDataSource({this.contentDirectory = 'assets/content'});

  final String contentDirectory;

  @override
  List<SiteContent> load() {
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

    final documents = [for (final file in files) _readDocument(file)];
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

    final contents = [for (final document in documents) _parseContent(document, links)];
    _ensureUniqueLocales(contents);
    return List.unmodifiable(contents);
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

  SiteContent _parseContent(_ContentDocument document, SiteLinks links) {
    final json = document.json;
    final path = document.path;

    return SiteContent(
      lang: _nonEmptyString(json, 'lang', path),
      route: _nonEmptyString(json, 'route', path),
      switchHref: _string(json, 'switchHref', path),
      switchHrefLang: _string(json, 'switchHrefLang', path),
      switchLabel: _string(json, 'switchLabel', path),
      switchAriaLabel: _string(json, 'switchAriaLabel', path),
      assetPrefix: _string(json, 'assetPrefix', path),
      homeHref: _string(json, 'homeHref', path),
      skipLink: _string(json, 'skipLink', path),
      metaTitle: _string(json, 'metaTitle', path),
      metaDescription: _string(json, 'metaDescription', path),
      canonicalUrl: _string(json, 'canonicalUrl', path),
      ogLocale: _string(json, 'ogLocale', path),
      ogImageAlt: _string(json, 'ogImageAlt', path),
      brandRole: _string(json, 'brandRole', path),
      homeLabel: _string(json, 'homeLabel', path),
      navAriaLabel: _string(json, 'navAriaLabel', path),
      socialAriaLabel: _string(json, 'socialAriaLabel', path),
      nav: _mapList(
        json,
        'nav',
        path,
        (item, itemPath) => NavItem(
          _string(item, 'label', itemPath),
          _string(item, 'href', itemPath),
        ),
      ),
      navCta: _string(json, 'navCta', path),
      mailto: _string(json, 'mailto', path),
      links: links,
      hero: _hero(_object(json['hero'], '$path.hero'), '$path.hero'),
      about: _about(_object(json['about'], '$path.about'), '$path.about'),
      mentoring: _mentoring(_object(json['mentoring'], '$path.mentoring'), '$path.mentoring'),
      experience: _experience(_object(json['experience'], '$path.experience'), '$path.experience'),
      toolkit: _toolkit(_object(json['toolkit'], '$path.toolkit'), '$path.toolkit'),
      work: _work(_object(json['work'], '$path.work'), '$path.work'),
      community: _community(_object(json['community'], '$path.community'), '$path.community'),
      footer: _footer(_object(json['footer'], '$path.footer'), '$path.footer'),
    );
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

  HeroContent _hero(Map<String, dynamic> json, String path) => HeroContent(
    kicker: _string(json, 'kicker', path),
    availability: _string(json, 'availability', path),
    availabilityNote: _string(json, 'availabilityNote', path),
    title: _string(json, 'title', path),
    titleEmphasis: _string(json, 'titleEmphasis', path),
    lede: _string(json, 'lede', path),
    primaryCta: _string(json, 'primaryCta', path),
    secondaryCta: _string(json, 'secondaryCta', path),
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
    portraitAlt: _string(json, 'portraitAlt', path),
    portraitRole: _string(json, 'portraitRole', path),
    portraitEducation: _string(json, 'portraitEducation', path),
    companiesLabel: _string(json, 'companiesLabel', path),
    companies: _strings(json, 'companies', path),
  );

  AboutContent _about(Map<String, dynamic> json, String path) => AboutContent(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    paragraphs: _strings(json, 'paragraphs', path),
    currentlyLabel: _string(json, 'currentlyLabel', path),
    currentlyRole: _string(json, 'currentlyRole', path),
    currentlyCompany: _string(json, 'currentlyCompany', path),
    currentlyPeriod: _string(json, 'currentlyPeriod', path),
  );

  MentoringContent _mentoring(Map<String, dynamic> json, String path) => MentoringContent(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    lede: _string(json, 'lede', path),
    forYouTitle: _string(json, 'forYouTitle', path),
    forYou: _strings(json, 'forYou', path),
    forYouNote: _string(json, 'forYouNote', path),
    forYouNoteCta: _string(json, 'forYouNoteCta', path),
    focusTitle: _string(json, 'focusTitle', path),
    focusAreas: _mapList(
      json,
      'focusAreas',
      path,
      (area, areaPath) => FocusArea(
        _string(area, 'title', areaPath),
        _string(area, 'description', areaPath),
      ),
    ),
    stepsTitle: _string(json, 'stepsTitle', path),
    steps: _mapList(
      json,
      'steps',
      path,
      (step, stepPath) => MentorStep(
        _string(step, 'title', stepPath),
        _string(step, 'description', stepPath),
      ),
    ),
    stepsNote: _string(json, 'stepsNote', path),
    getTitle: _string(json, 'getTitle', path),
    getItems: _strings(json, 'getItems', path),
    ctaTitle: _string(json, 'ctaTitle', path),
    ctaText: _string(json, 'ctaText', path),
    ctaButton: _string(json, 'ctaButton', path),
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

  CommunityContent _community(Map<String, dynamic> json, String path) => CommunityContent(
    eyebrow: _string(json, 'eyebrow', path),
    heading: _string(json, 'heading', path),
    items: _mapList(
      json,
      'items',
      path,
      (item, itemPath) => CommunityItem(
        label: _string(item, 'label', itemPath),
        description: _string(item, 'description', itemPath),
        links: _linkRefs(item, itemPath),
      ),
    ),
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

  void _ensureUniqueLocales(List<SiteContent> contents) {
    final langs = <String>{};
    final routes = <String>{};

    for (final content in contents) {
      if (!langs.add(content.lang)) {
        throw FormatException('Duplicate locale "${content.lang}" in $contentDirectory.');
      }
      if (!routes.add(content.route)) {
        throw FormatException('Duplicate route "${content.route}" in $contentDirectory.');
      }
    }
  }
}

final class _ContentDocument {
  const _ContentDocument(this.path, this.json);

  final String path;
  final Map<String, dynamic> json;
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
