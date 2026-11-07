/// Immutable content models rendered by the site.
///
/// These are plain data classes: the actual copy and URLs are loaded from the
/// JSON assets in `assets/content/` by the data layer, and the abstraction is
/// `domain/repository.dart`.
library;

import 'site_links.dart';

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
    required this.title,
    required this.titleEmphasis,
    required this.lede,
    required this.primaryCta,
    required this.secondaryCta,
    required this.note,
    required this.stats,
    required this.portraitAlt,
    required this.portraitRole,
    required this.portraitEducation,
    required this.companiesLabel,
    required this.companies,
  });

  final String kicker;
  final String availability;
  final String availabilityNote;
  final String title;
  final String titleEmphasis;
  final String lede;
  final String primaryCta;
  final String secondaryCta;
  final String note;
  final List<HeroStat> stats;
  final String portraitAlt;
  final String portraitRole;
  final String portraitEducation;
  final String companiesLabel;
  final List<String> companies;
}

class AboutContent {
  const AboutContent({
    required this.eyebrow,
    required this.heading,
    required this.paragraphs,
    required this.currentlyLabel,
    required this.currentlyRole,
    required this.currentlyCompany,
    required this.currentlyPeriod,
  });

  final String eyebrow;
  final String heading;
  final List<String> paragraphs;
  final String currentlyLabel;
  final String currentlyRole;
  final String currentlyCompany;
  final String currentlyPeriod;
}

class FocusArea {
  const FocusArea(this.title, this.description);

  final String title;
  final String description;
}

class MentorStep {
  const MentorStep(this.title, this.description);

  final String title;
  final String description;
}

class MentoringContent {
  const MentoringContent({
    required this.eyebrow,
    required this.heading,
    required this.lede,
    required this.forYouTitle,
    required this.forYou,
    required this.forYouNote,
    required this.forYouNoteCta,
    required this.focusTitle,
    required this.focusAreas,
    required this.stepsTitle,
    required this.steps,
    required this.stepsNote,
    required this.getTitle,
    required this.getItems,
    required this.ctaTitle,
    required this.ctaText,
    required this.ctaButton,
  });

  final String eyebrow;
  final String heading;
  final String lede;
  final String forYouTitle;
  final List<String> forYou;
  final String forYouNote;
  final String forYouNoteCta;
  final String focusTitle;
  final List<FocusArea> focusAreas;
  final String stepsTitle;
  final List<MentorStep> steps;
  final String stepsNote;
  final String getTitle;
  final List<String> getItems;
  final String ctaTitle;
  final String ctaText;
  final String ctaButton;
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

class CommunityItem {
  const CommunityItem({
    required this.label,
    required this.description,
    this.links = const [],
  });

  final String label;
  final String description;
  final List<LinkRef> links;
}

class CommunityContent {
  const CommunityContent({
    required this.eyebrow,
    required this.heading,
    required this.items,
  });

  final String eyebrow;
  final String heading;
  final List<CommunityItem> items;
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
    required this.brandRole,
    required this.homeLabel,
    required this.navAriaLabel,
    required this.socialAriaLabel,
    required this.nav,
    required this.navCta,
    required this.mailto,
    required this.links,
    required this.hero,
    required this.about,
    required this.mentoring,
    required this.experience,
    required this.toolkit,
    required this.work,
    required this.community,
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
  final String brandRole;
  final String homeLabel;
  final String navAriaLabel;
  final String socialAriaLabel;
  final List<NavItem> nav;
  final String navCta;
  final String mailto;
  final SiteLinks links;
  final HeroContent hero;
  final AboutContent about;
  final MentoringContent mentoring;
  final ExperienceContent experience;
  final ToolkitContent toolkit;
  final WorkContent work;
  final CommunityContent community;
  final FooterContent footer;
}
