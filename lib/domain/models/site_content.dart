/// Immutable content models rendered by the site.
///
/// These are plain data classes: the actual copy and URLs are loaded from the
/// JSON assets in `assets/content/` by the data layer, and the abstraction is
/// `domain/repository.dart`.
library;

import 'package:gabriel_moro_site/domain/models/site_links.dart';

/// The pages every locale publishes.
///
/// The `id` is stable across locales; the localized URL slug lives in the
/// content assets.
enum PageId { home, about, content, work, experience, mentoring }

/// One `hreflang` alternate for a page.
class PageAlternate {
  const PageAlternate({required this.hrefLang, required this.url});

  final String hrefLang;
  final String url;
}

/// One entry in the masthead tab bar, already resolved for the current page.
class NavItem {
  const NavItem({
    required this.id,
    required this.label,
    required this.summary,
    required this.href,
    required this.current,
  });

  final PageId id;
  final String label;

  /// One-line description rendered by the home page's page index.
  final String summary;

  /// Href relative to the page rendering the tab bar.
  final String href;

  /// Whether this entry is the page being rendered.
  final bool current;
}

/// A localized page rendered at a concrete route.
///
/// A [SiteContent] carries the copy of a whole locale; a [SitePage] picks one
/// page out of it and holds the links and metadata that change with the route.
class SitePage {
  const SitePage({
    required this.content,
    required this.id,
    required this.route,
    required this.navLabel,
    required this.summary,
    required this.title,
    required this.description,
    required this.canonicalUrl,
    required this.assetPrefix,
    required this.homeHref,
    required this.switchHref,
    required this.nav,
    required this.alternates,
  });

  final SiteContent content;
  final PageId id;

  /// Site-root path of the page, e.g. `/`, `/sobre` or `/en/about`.
  final String route;

  /// Tab label; null keeps the page out of the tab bar (the home page).
  final String? navLabel;

  /// One-line description rendered by the home page's page index.
  final String? summary;

  final String title;
  final String description;
  final String canonicalUrl;

  /// Prefix that climbs from this page to the site root (`./`, `../`, ...).
  final String assetPrefix;

  /// Link back to the locale's home page.
  final String homeHref;

  /// Link to this same page in the other locale.
  final String switchHref;

  /// Tab bar entries, already relative to this page.
  final List<NavItem> nav;

  /// `hreflang` alternates for every published locale, default locale first.
  final List<PageAlternate> alternates;

  /// Returns a page that points at merged [content] while keeping its own
  /// route metadata. The repository uses this after merging feed articles.
  SitePage withContent(SiteContent content) => SitePage(
    content: content,
    id: id,
    route: route,
    navLabel: navLabel,
    summary: summary,
    title: title,
    description: description,
    canonicalUrl: canonicalUrl,
    assetPrefix: assetPrefix,
    homeHref: homeHref,
    switchHref: switchHref,
    nav: nav,
    alternates: alternates,
  );
}

class HeroStat {
  const HeroStat(this.value, this.label);

  final String value;
  final String label;
}

class HeroContent {
  const HeroContent({
    required this.kicker,
    required this.availability,
    required this.availabilityNote,
    required this.lede,
    required this.primaryCta,
    required this.primaryCtaHref,
    required this.secondaryCta,
    required this.secondaryCtaHref,
    required this.note,
    required this.stats,
  });

  final String kicker;
  final String availability;
  final String availabilityNote;
  final String lede;
  final String primaryCta;

  /// Link relative to the locale's home page, where the hero is rendered.
  final String primaryCtaHref;
  final String secondaryCta;

  /// Link relative to the locale's home page, where the hero is rendered.
  final String secondaryCtaHref;
  final String note;
  final List<HeroStat> stats;
}

class CurrentRole {
  const CurrentRole({
    required this.role,
    required this.company,
    required this.period,
    this.url,
  });

  final String role;
  final String company;
  final String period;
  final String? url;
}

class EducationEntry {
  const EducationEntry({
    required this.degree,
    required this.institution,
    required this.url,
  });

  final String degree;
  final String institution;
  final String url;
}

class AboutTopic {
  const AboutTopic({required this.title, required this.paragraphs});

  final String title;
  final List<String> paragraphs;
}

class AboutContent {
  const AboutContent({
    required this.eyebrow,
    required this.heading,
    required this.intro,
    required this.sections,
    required this.currentlyLabel,
    required this.currentRoles,
    required this.contactLabel,
    required this.contactText,
    required this.portraitAlt,
    required this.portraitRole,
    required this.educationConnector,
    required this.education,
  });

  final String eyebrow;
  final String heading;
  final String intro;
  final List<AboutTopic> sections;
  final String currentlyLabel;
  final List<CurrentRole> currentRoles;
  final String contactLabel;
  final String contactText;
  final String portraitAlt;
  final String portraitRole;

  /// Preposition between a degree and its institution ("pela" / "from").
  final String educationConnector;
  final List<EducationEntry> education;
}

class Article {
  const Article({
    required this.title,
    required this.publication,
    required this.sourceId,
    required this.published,
    required this.url,
    this.thumbnail,
  });

  final String title;
  final String publication;

  /// Stable publication key used by the articles filter (`koin-developers`,
  /// `codandotv`). It is not shown to readers.
  final String sourceId;

  /// Localized publication date, such as `Sep 2026` or `Set 2026`.
  final String published;
  final String url;

  /// Absolute HTTPS cover URL from Medium, or null when the article has no
  /// cover.
  final String? thumbnail;
}

class Video {
  const Video({
    required this.title,
    required this.published,
    required this.url,
    required this.thumbnail,
    required this.embedUrl,
  });

  final String title;

  /// Localized publication date, such as `Sep 2026` or `Set 2026`.
  final String published;

  /// Absolute YouTube watch URL.
  final String url;

  /// Absolute HTTPS thumbnail URL.
  final String thumbnail;

  /// Absolute YouTube embed URL used by the inline player.
  final String embedUrl;
}

class ContentChannel {
  const ContentChannel({
    required this.label,
    required this.description,
    this.links = const [],
  });

  final String label;
  final String description;
  final List<LinkRef> links;
}

class ContentRecognition {
  const ContentRecognition({
    required this.label,
    required this.description,
    required this.linkLabel,
    required this.url,
  });

  final String label;
  final String description;
  final String linkLabel;
  final String url;
}

class ContentHub {
  const ContentHub({
    required this.eyebrow,
    required this.heading,
    required this.lede,
    required this.latestTitle,
    required this.videosTitle,
    required this.filterAllLabel,
    required this.filterAriaLabel,
    required this.contentFilterAriaLabel,
    required this.filterArticlesLabel,
    required this.filterVideosLabel,
    required this.articleMonths,
    required this.articles,
    required this.videos,
    required this.allArticlesLabel,
    required this.allArticlesHref,
    required this.allVideosLabel,
    required this.allVideosHref,
    required this.channelsTitle,
    required this.channels,
    required this.topicsTitle,
    required this.topics,
    required this.recognition,
    required this.ctaTitle,
    required this.ctaText,
    required this.ctaButton,
    required this.ctaHref,
  });

  final String eyebrow;
  final String heading;
  final String lede;
  final String latestTitle;
  final String videosTitle;

  /// Label of the filter chip that shows every article.
  final String filterAllLabel;

  /// Accessible name of the article filter group.
  final String filterAriaLabel;

  /// Accessible name of the article/video filter group.
  final String contentFilterAriaLabel;

  /// Labels of the filter chips that switch between the two feed lists.
  final String filterArticlesLabel;
  final String filterVideosLabel;

  /// Localized month abbreviations used to format feed publication dates.
  final List<String> articleMonths;

  /// Articles rendered by the hub. The JSON data source leaves this empty;
  /// the repository fills it from the Medium data source.
  final List<Article> articles;

  /// Videos rendered by the hub. The JSON data source leaves this empty;
  /// the repository fills it from the YouTube playlist data source.
  final List<Video> videos;
  final String allArticlesLabel;
  final String allArticlesHref;
  final String allVideosLabel;
  final String allVideosHref;
  final String channelsTitle;
  final List<ContentChannel> channels;
  final String topicsTitle;
  final List<String> topics;
  final ContentRecognition recognition;
  final String ctaTitle;
  final String ctaText;
  final String ctaButton;
  final String ctaHref;

  /// Returns a copy with different feed lists, keeping the rest of the hub
  /// untouched. The repository uses this after merging the feeds.
  ContentHub withContent({
    required List<Article> articles,
    required List<Video> videos,
  }) => ContentHub(
    eyebrow: eyebrow,
    heading: heading,
    lede: lede,
    latestTitle: latestTitle,
    videosTitle: videosTitle,
    filterAllLabel: filterAllLabel,
    filterAriaLabel: filterAriaLabel,
    contentFilterAriaLabel: contentFilterAriaLabel,
    filterArticlesLabel: filterArticlesLabel,
    filterVideosLabel: filterVideosLabel,
    articleMonths: articleMonths,
    articles: articles,
    videos: videos,
    allArticlesLabel: allArticlesLabel,
    allArticlesHref: allArticlesHref,
    allVideosLabel: allVideosLabel,
    allVideosHref: allVideosHref,
    channelsTitle: channelsTitle,
    channels: channels,
    topicsTitle: topicsTitle,
    topics: topics,
    recognition: recognition,
    ctaTitle: ctaTitle,
    ctaText: ctaText,
    ctaButton: ctaButton,
    ctaHref: ctaHref,
  );
}

class Role {
  const Role({
    required this.company,
    required this.title,
    required this.period,
    required this.bullets,
  });

  final String company;
  final String title;
  final String period;
  final List<String> bullets;
}

class ExperienceContent {
  const ExperienceContent({
    required this.eyebrow,
    required this.heading,
    required this.lede,
    required this.roles,
    required this.linkLabel,
  });

  final String eyebrow;
  final String heading;
  final String lede;
  final List<Role> roles;
  final String linkLabel;
}

class SkillGroup {
  const SkillGroup(this.label, this.value);

  final String label;
  final String value;
}

class ToolkitContent {
  const ToolkitContent({
    required this.eyebrow,
    required this.heading,
    required this.groups,
  });

  final String eyebrow;
  final String heading;
  final List<SkillGroup> groups;
}

class Project {
  const Project({
    required this.name,
    required this.description,
    required this.tags,
    required this.url,
    required this.linkLabel,
  });

  final String name;
  final String description;
  final List<String> tags;
  final String url;
  final String linkLabel;
}

class WorkContent {
  const WorkContent({
    required this.eyebrow,
    required this.heading,
    required this.lede,
    required this.projects,
  });

  final String eyebrow;
  final String heading;
  final String lede;
  final List<Project> projects;
}

class ExploreContent {
  const ExploreContent({
    required this.eyebrow,
    required this.heading,
    required this.lede,
  });

  final String eyebrow;
  final String heading;
  final String lede;
}

class MentoringTopic {
  const MentoringTopic({required this.label, required this.description});

  final String label;
  final String description;
}

class MentoringStep {
  const MentoringStep({required this.title, required this.description});

  final String title;
  final String description;
}

class MentoringContent {
  const MentoringContent({
    required this.eyebrow,
    required this.heading,
    required this.lede,
    required this.availability,
    required this.availabilityNote,
    required this.primaryCta,
    required this.primaryCtaHref,
    required this.ctaNote,
    required this.audienceTitle,
    required this.audience,
    required this.topicsTitle,
    required this.topics,
    required this.stepsTitle,
    required this.steps,
    required this.outcomesTitle,
    required this.outcomes,
    required this.closingTitle,
    required this.closingText,
    required this.closingCta,
    required this.closingHref,
  });

  final String eyebrow;
  final String heading;
  final String lede;
  final String availability;
  final String availabilityNote;
  final String primaryCta;

  /// Absolute or external URL, such as a `mailto:` link.
  final String primaryCtaHref;
  final String ctaNote;
  final String audienceTitle;
  final List<String> audience;
  final String topicsTitle;
  final List<MentoringTopic> topics;
  final String stepsTitle;
  final List<MentoringStep> steps;
  final String outcomesTitle;
  final List<String> outcomes;
  final String closingTitle;
  final String closingText;
  final String closingCta;
  final String closingHref;
}

class LinkRef {
  const LinkRef(this.label, this.url);

  final String label;
  final String url;
}

class FooterContent {
  const FooterContent({
    required this.heading,
    required this.text,
    required this.cta,
    required this.availability,
    required this.copyright,
    required this.builtWith,
    required this.links,
  });

  final String heading;
  final String text;
  final String cta;
  final String availability;
  final String copyright;
  final String builtWith;
  final List<LinkRef> links;
}

class SiteContent {
  const SiteContent({
    required this.lang,
    required this.route,
    required this.switchHrefLang,
    required this.switchLabel,
    required this.switchAriaLabel,
    required this.skipLink,
    required this.ogLocale,
    required this.ogImageAlt,
    required this.siteTitle,
    required this.tagline,
    required this.coverImage,
    required this.homeLabel,
    required this.navAriaLabel,
    required this.socialAriaLabel,
    required this.navCta,
    required this.navCtaHref,
    required this.mailto,
    required this.links,
    required this.hero,
    required this.about,
    required this.contentHub,
    required this.experience,
    required this.toolkit,
    required this.work,
    required this.explore,
    required this.mentoring,
    required this.footer,
  });

  final String lang;

  /// Route of the locale's home page (`/` or `/en`).
  final String route;

  /// Language tag the locale switch points at.
  final String switchHrefLang;
  final String switchLabel;
  final String switchAriaLabel;

  final String skipLink;
  final String ogLocale;
  final String ogImageAlt;

  /// Site wordmark shown in the masthead.
  final String siteTitle;

  /// Short phrase rendered under [siteTitle].
  final String tagline;

  /// Decorative cover image path relative to the site root, without the
  /// page's `assetPrefix`. Null falls back to the CSS-only cover.
  final String? coverImage;
  final String homeLabel;
  final String navAriaLabel;
  final String socialAriaLabel;
  final String navCta;
  final String navCtaHref;
  final String mailto;
  final SiteLinks links;
  final HeroContent hero;
  final AboutContent about;
  final ContentHub contentHub;
  final ExperienceContent experience;
  final ToolkitContent toolkit;
  final WorkContent work;
  final ExploreContent explore;
  final MentoringContent mentoring;
  final FooterContent footer;

  /// Returns a copy with a different content hub, keeping the rest of the
  /// locale untouched. The repository uses this after merging feed articles.
  SiteContent withContentHub(ContentHub contentHub) => SiteContent(
    lang: lang,
    route: route,
    switchHrefLang: switchHrefLang,
    switchLabel: switchLabel,
    switchAriaLabel: switchAriaLabel,
    skipLink: skipLink,
    ogLocale: ogLocale,
    ogImageAlt: ogImageAlt,
    siteTitle: siteTitle,
    tagline: tagline,
    coverImage: coverImage,
    homeLabel: homeLabel,
    navAriaLabel: navAriaLabel,
    socialAriaLabel: socialAriaLabel,
    navCta: navCta,
    navCtaHref: navCtaHref,
    mailto: mailto,
    links: links,
    hero: hero,
    about: about,
    contentHub: contentHub,
    experience: experience,
    toolkit: toolkit,
    work: work,
    explore: explore,
    mentoring: mentoring,
    footer: footer,
  );
}
