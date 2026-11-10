/// Immutable content models rendered by the site.
///
/// These are plain data classes: the actual copy and URLs are loaded from the
/// JSON assets in `assets/content/` by the data layer, and the abstraction is
/// `domain/repository.dart`.
library;

import 'package:gabriel_moro_site/domain/models/site_links.dart';

class NavItem {
  const NavItem(this.label, this.href);

  final String label;
  final String href;
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
  final String primaryCtaHref;
  final String secondaryCta;
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
    required this.portraitEducation,
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
  final String portraitEducation;
}

class Article {
  const Article({
    required this.title,
    required this.publication,
    required this.published,
    required this.url,
    this.thumbnail,
  });

  final String title;
  final String publication;
  final String published;
  final String url;

  /// Cover image path relative to the site root, without the locale's
  /// `assetPrefix`. Null when the article has no local thumbnail.
  final String? thumbnail;
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
    required this.articles,
    required this.allArticlesLabel,
    required this.allArticlesHref,
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
  final List<Article> articles;
  final String allArticlesLabel;
  final String allArticlesHref;
  final String channelsTitle;
  final List<ContentChannel> channels;
  final String topicsTitle;
  final List<String> topics;
  final ContentRecognition recognition;
  final String ctaTitle;
  final String ctaText;
  final String ctaButton;
  final String ctaHref;
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
    required this.switchHref,
    required this.switchHrefLang,
    required this.switchLabel,
    required this.switchAriaLabel,
    required this.assetPrefix,
    required this.homeHref,
    required this.skipLink,
    required this.metaTitle,
    required this.metaDescription,
    required this.canonicalUrl,
    required this.ogLocale,
    required this.ogImageAlt,
    required this.siteTitle,
    required this.tagline,
    required this.coverImage,
    required this.homeLabel,
    required this.navAriaLabel,
    required this.socialAriaLabel,
    required this.nav,
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
    required this.footer,
  });

  final String lang;

  /// Route path used by the router.
  final String route;

  /// Link to the other locale.
  final String switchHref;
  final String switchHrefLang;
  final String switchLabel;
  final String switchAriaLabel;

  /// Prefix for assets, relative to the page ('' at the root, '../' below it).
  final String assetPrefix;

  /// Link back to the home page, relative to the current page.
  final String homeHref;
  final String skipLink;
  final String metaTitle;
  final String metaDescription;
  final String canonicalUrl;
  final String ogLocale;
  final String ogImageAlt;

  /// Site wordmark shown in the masthead.
  final String siteTitle;

  /// Short phrase rendered under [siteTitle].
  final String tagline;

  /// Decorative cover image path relative to the site root, without the
  /// locale's `assetPrefix`. Null falls back to the CSS-only cover.
  final String? coverImage;
  final String homeLabel;
  final String navAriaLabel;
  final String socialAriaLabel;
  final List<NavItem> nav;
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
  final FooterContent footer;
}
