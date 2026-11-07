import '../domain/models/site_content.dart';
import '../domain/models/site_links.dart';
import '../domain/repository.dart';

const _siteUrl = 'https://gabrielbmoro.github.io/gabrielbmoro/';
const _emailAddress = 'gabrielbronzattimoro.es@gmail.com';
const _linkedInUrl = 'https://www.linkedin.com/in/gabrielbronzattimoro15031994/';
const _gitHubUrl = 'https://github.com/gabrielbmoro';
const _mediumUrl = 'https://medium.com/@gabrielbronzattimoro.es';
const _youTubeUrl = 'https://www.youtube.com/@CodandoTV';
const _codandoTvUrl = 'https://codandotv.com/#creators';
const _koinChampionUrl = 'https://koinchampion.kotzilla.io/apply-now';

const _links = SiteLinks(
  siteUrl: _siteUrl,
  email: _emailAddress,
  linkedInUrl: _linkedInUrl,
  gitHubUrl: _gitHubUrl,
  mediumUrl: _mediumUrl,
  youTubeUrl: _youTubeUrl,
  codandoTvUrl: _codandoTvUrl,
  koinChampionUrl: _koinChampionUrl,
);

/// Content repository backed by the copy versioned in this file.
final class SiteContentRepositoryImpl implements SiteContentRepository {
  const SiteContentRepositoryImpl();

  static const _en = SiteContent(
    lang: 'en',
    route: '/',
    switchHref: 'pt-br/',
    switchHrefLang: 'pt-BR',
    switchLabel: 'PT',
    switchAriaLabel: 'Ver esta página em português',
    assetPrefix: '',
    homeHref: './',
    skipLink: 'Skip to content',
    metaTitle: 'Gabriel Moro — Senior Mobile Engineer & 1:1 Mentor',
    metaDescription:
        'Senior mobile engineer and tech lead working with Android, Kotlin Multiplatform and Flutter. '
        '1:1 mentoring for developers moving into senior and lead roles. The first call is free.',
    canonicalUrl: _siteUrl,
    ogLocale: 'en_US',
    ogImageAlt: 'Gabriel Moro',
    brandRole: 'Mobile engineer & mentor',
    homeLabel: 'Gabriel Moro — home',
    navAriaLabel: 'Primary navigation',
    socialAriaLabel: 'Social links',
    nav: [
      NavItem('About', '#about'),
      NavItem('Mentoring', '#mentoring'),
      NavItem('Experience', '#experience'),
      NavItem('Work', '#work'),
    ],
    navCta: 'Book a call',
    mailto: 'mailto:$_emailAddress?subject=1%3A1%20Mentoring%20-%20free%20intro%20call',
    links: _links,
    hero: HeroContent(
      kicker: 'Senior mobile engineer & tech lead',
      availability: 'Open for 1:1 mentoring',
      availabilityNote: 'First call free',
      title: 'Become the mobile engineer ',
      titleEmphasis: 'teams trust to lead.',
      lede:
          'I’m Gabriel Moro. For almost a decade I’ve built Android, Kotlin Multiplatform and Flutter products '
          'used by millions — and I mentor the developers who want to grow into senior and lead roles.',
      primaryCta: 'Book a free intro call',
      secondaryCta: 'How mentoring works',
      note: '30 minutes · Online · English or Portuguese',
      stats: [
        HeroStat('35M+', 'users on products I’ve shipped'),
        HeroStat('100M+', 'app downloads'),
        HeroStat('2017', 'building mobile since'),
      ],
      portraitAlt: 'Portrait of Gabriel Moro, smiling and wearing glasses.',
      portraitRole: 'Senior Mobile Engineer at Kobe',
      portraitEducation: 'M.Sc. in Computer Science · UFRGS',
      companiesLabel: 'Shipped with',
      companies: ['Ambush', 'TELUS Digital', 'Socialive', 'Kobe'],
    ),
    about: AboutContent(
      eyebrow: 'About',
      heading: 'Hands-on engineering, human mentoring.',
      paragraphs: [
        'I’ve been a mobile engineer since 2017, building and leading products at scale — apps with 35M+ users '
            'and 100M+ downloads — as a senior engineer and tech lead. Today I work with Flutter and the VTEX '
            'ecosystem at Kobe.',
        'Teaching has always been part of the job, not an extra. I’ve mentored developers, run internal workshops, '
            'spoken at GDGs and written about mobile for years. My approach is simple: less abstract theory, more '
            'code, architecture decisions and a concrete next step.',
      ],
      currentlyLabel: 'Currently',
      currentlyRole: 'Senior Mobile Engineer',
      currentlyCompany: 'Kobe',
      currentlyPeriod: 'Sep 2026 — Present',
    ),
    mentoring: MentoringContent(
      eyebrow: '1:1 Mentoring',
      heading: 'Guidance from someone who has already walked the path.',
      lede:
          'A few 1:1 slots open for developers who want to grow faster than they could alone — combining almost '
          'a decade of mobile in production with hands-on mentoring of Android and Kotlin Multiplatform teams.',
      forYouTitle: 'Who it’s for',
      forYou: [
        'Mid-level developers aiming for a senior role.',
        'Senior developers stepping into technical leadership.',
        'Android and Flutter developers moving into Kotlin Multiplatform.',
        'Anyone preparing for international hiring processes.',
      ],
      forYouNote: 'Not sure if it’s a fit?',
      forYouNoteCta: 'Start with a free intro call',
      focusTitle: 'What we can work on',
      focusAreas: [
        FocusArea(
          'Career',
          'The senior and tech-lead transition, growth plans, positioning and portfolio.',
        ),
        FocusArea(
          'Android & KMP',
          'Compose Multiplatform, multi-module architecture and platform-specific integrations.',
        ),
        FocusArea(
          'Architecture & quality',
          'MVVM/MVI, modularization, testing strategy, Detekt and architectural rules.',
        ),
        FocusArea(
          'International interviews',
          'Technical prep, mobile system design and technical English.',
        ),
        FocusArea(
          'AI in the workflow',
          'Claude Code, agents and AI-assisted development, with critical review of what gets generated.',
        ),
        FocusArea(
          'Open source & content',
          'Shipping and maintaining libraries, building a public portfolio and creating technical content.',
        ),
      ],
      stepsTitle: 'How it works',
      steps: [
        MentorStep(
          'You write',
          'A short email with your goal and the context you’re in today.',
        ),
        MentorStep(
          'Free intro call · 30 min',
          'We align expectations, check the fit and define the focus.',
        ),
        MentorStep(
          '1:1 sessions · 1h',
          'Online, in Portuguese or English, with a clear action plan between meetings.',
        ),
      ],
      stepsNote: 'Investment and format are agreed on the intro call, based on your goal.',
      getTitle: 'What you get',
      getItems: [
        'A personalized development plan with concrete next steps.',
        'Code and architecture review of your projects.',
        'Materials, references and exercises targeted at your goal.',
        'Async support by email between sessions.',
      ],
      ctaTitle: 'The first call is free.',
      ctaText: 'Tell me where you are and where you want to go. We’ll figure out the next step together.',
      ctaButton: 'Book my intro call',
    ),
    experience: ExperienceContent(
      eyebrow: 'Experience',
      heading: 'Almost a decade shipping mobile products.',
      lede: 'Recent roles. Earlier history on LinkedIn.',
      roles: [
        Role(
          company: 'Kobe',
          title: 'Senior Mobile Engineer',
          period: 'Sep 2026 — Present',
          bullets: [
            'Building and evolving mobile e-commerce apps with Flutter and Dart, across the full product lifecycle.',
            'Improving architecture, engineering practices and automated testing for scalable, high-quality delivery.',
            'Integrating with the VTEX ecosystem and supporting technical leadership, code reviews and mentoring.',
          ],
        ),
        Role(
          company: 'Ambush',
          title: 'Senior Mobile Engineer',
          period: 'Nov 2023 — Aug 2026',
          bullets: [
            'Core features for a cash-back app with 35M+ users, handling millions of daily transactions.',
            'Led Kotlin Multiplatform (Compose Multiplatform) adoption and mentored mobile developers.',
            'Feature flags, CI/CD with linting and Maestro UI tests, and architecture standards across the team.',
          ],
        ),
        Role(
          company: 'TELUS Digital',
          title: 'Senior Android Engineer',
          period: 'Jul 2023 — Nov 2023',
          bullets: [
            'Delivered Android features for a carrier app with 25M–35M+ active users and 100M+ downloads.',
            'Mentored Android developers and built complex features with Hilt, Jetpack Compose and multi-module projects.',
          ],
        ),
        Role(
          company: 'Socialive',
          title: 'Senior Android Engineer',
          period: 'Jul 2021 — Jun 2023',
          bullets: [
            'Built core Android features for an enterprise video recording and livestreaming app.',
            'Implemented HD local recording, low-latency capture and a dynamic multi-participant video display.',
            'Worked with WebRTC, Dagger and Jetpack Components on a live production product.',
          ],
        ),
      ],
      linkLabel: 'Full history on LinkedIn',
    ),
    toolkit: ToolkitContent(
      eyebrow: 'Toolkit',
      heading: 'Tools I reach for.',
      groups: [
        SkillGroup('Platforms', 'Android, Kotlin Multiplatform, Compose Multiplatform, Jetpack Compose, Flutter, Dart'),
        SkillGroup('Architecture', 'MVVM, MVI, multi-module architecture, SOLID, reactive programming'),
        SkillGroup('Libraries', 'Koin, Ktor, Coroutines, Room, Coil, GetX, MobX'),
        SkillGroup('Quality', 'Unit and UI testing, Maestro, Paparazzi, Detekt, architecture validation'),
        SkillGroup('Delivery', 'Gradle, GitHub Actions, Fastlane, Danger, CLI development, BuildKonfig'),
        SkillGroup('AI workflow', 'Claude Code, Open Code, agentic development'),
      ],
    ),
    work: WorkContent(
      eyebrow: 'Selected work',
      heading: 'Open source developers depend on.',
      lede: 'Libraries and tools I created and maintain.',
      projects: [
        Project(
          name: 'Popcorn Guineapig',
          description:
              'A lightweight toolset that automates and enforces architectural guidelines in multi-module Kotlin '
              'and Android projects.',
          tags: ['Kotlin', 'Detekt', 'Maven Central'],
          url: 'https://github.com/CodandoTV/popcorn-guineapig',
          linkLabel: 'View on GitHub',
        ),
        Project(
          name: 'JujubaSVG',
          description:
              'Granular SVG manipulation — including editing properties by ID — for Compose Multiplatform, '
              'Android and Flutter.',
          tags: ['Kotlin', 'Dart', 'Maven Central', 'pub.dev'],
          url: 'https://github.com/CodandoTV/jujubaSVG',
          linkLabel: 'View on GitHub',
        ),
        Project(
          name: 'EagleEye',
          description:
              'A Dart CLI that detects architectural violations and forbidden dependency patterns in Flutter '
              'and Dart projects.',
          tags: ['Dart', 'CLI', 'pub.dev'],
          url: 'https://github.com/CodandoTV/eagle-eye',
          linkLabel: 'View on GitHub',
        ),
        Project(
          name: 'MovieDB-App',
          description:
              'A reference app for modern Compose Multiplatform and Kotlin Multiplatform, selected for Google '
              'Dev Library.',
          tags: ['KMP', 'Compose', 'Dev Library'],
          url: 'https://github.com/gabrielbmoro/MovieDB-App',
          linkLabel: 'View on GitHub',
        ),
      ],
    ),
    community: CommunityContent(
      eyebrow: 'Community',
      heading: 'Sharing what I learn.',
      items: [
        CommunityItem(
          label: 'Talks',
          description: 'GDG Groups and GDG DevFest — mobile development, architecture and Kotlin for the community.',
        ),
        CommunityItem(
          label: 'Articles',
          description: 'Code review, navigation and testing on Medium.',
          links: [LinkRef('Read on Medium', _mediumUrl)],
        ),
        CommunityItem(
          label: 'CodandoTV',
          description: 'Technical videos, open source libraries and a podcast for the Brazilian developer community.',
          links: [
            LinkRef('Watch on YouTube', _youTubeUrl),
            LinkRef('codandotv.com', _codandoTvUrl),
          ],
        ),
        CommunityItem(
          label: 'Koin Champion',
          description: 'Recognized by Kotzilla for expert articles and real-world Koin use cases.',
          links: [LinkRef('Kotzilla', _koinChampionUrl)],
        ),
      ],
    ),
    footer: FooterContent(
      heading: 'Let’s find your next step.',
      text:
          'If you’re ready to grow into the next role, I’d like to help. Send a short note and we’ll start '
          'from there.',
      cta: 'Send an email',
      availability: 'Open for 1:1 mentoring',
      copyright: '© 2026 Gabriel Bronzatti Moro',
      builtWith: 'Built with Jaspr · Hosted on GitHub Pages',
      links: [
        LinkRef('LinkedIn', _linkedInUrl),
        LinkRef('GitHub', _gitHubUrl),
        LinkRef('Medium', _mediumUrl),
        LinkRef('YouTube', _youTubeUrl),
      ],
    ),
  );

  static const _ptBr = SiteContent(
    lang: 'pt-BR',
    route: '/pt-br',
    switchHref: '../',
    switchHrefLang: 'en',
    switchLabel: 'EN',
    switchAriaLabel: 'View this page in English',
    assetPrefix: '../',
    homeHref: '../',
    skipLink: 'Ir para o conteúdo',
    metaTitle: 'Gabriel Moro — Engenheiro Mobile Sênior & Mentor 1:1',
    metaDescription:
        'Engenheiro mobile sênior e tech lead com Android, Kotlin Multiplatform e Flutter. '
        'Mentoria 1:1 para desenvolvedores que querem chegar a papéis sênior e de liderança. A primeira conversa é grátis.',
    canonicalUrl: '${_siteUrl}pt-br/',
    ogLocale: 'pt_BR',
    ogImageAlt: 'Gabriel Moro',
    brandRole: 'Engenheiro mobile & mentor',
    homeLabel: 'Gabriel Moro — início',
    navAriaLabel: 'Navegação principal',
    socialAriaLabel: 'Links sociais',
    nav: [
      NavItem('Sobre', '#about'),
      NavItem('Mentoria', '#mentoring'),
      NavItem('Experiência', '#experience'),
      NavItem('Projetos', '#work'),
    ],
    navCta: 'Agendar conversa',
    mailto: 'mailto:$_emailAddress?subject=Mentoria%201%3A1%20-%20conversa%20gratuita',
    links: _links,
    hero: HeroContent(
      kicker: 'Engenheiro mobile sênior & tech lead',
      availability: 'Aberto para mentorias 1:1',
      availabilityNote: 'Primeira conversa grátis',
      title: 'Se torne o engenheiro mobile ',
      titleEmphasis: 'em quem os times confiam para liderar.',
      lede:
          'Sou o Gabriel Moro. Há quase uma década construo produtos Android, Kotlin Multiplatform e Flutter '
          'usados por milhões de pessoas — e oriento desenvolvedores que querem chegar a papéis sênior e de '
          'liderança.',
      primaryCta: 'Agendar conversa gratuita',
      secondaryCta: 'Como funciona a mentoria',
      note: '30 minutos · Online · Português ou inglês',
      stats: [
        HeroStat('35M+', 'usuários em produtos que ajudei a construir'),
        HeroStat('100M+', 'downloads nos apps'),
        HeroStat('2017', 'construindo mobile desde'),
      ],
      portraitAlt: 'Retrato de Gabriel Moro sorrindo, de óculos.',
      portraitRole: 'Senior Mobile Engineer na Kobe',
      portraitEducation: 'Mestrado em Ciência da Computação · UFRGS',
      companiesLabel: 'Experiência em',
      companies: ['Ambush', 'TELUS Digital', 'Socialive', 'Kobe'],
    ),
    about: AboutContent(
      eyebrow: 'Sobre',
      heading: 'Engenharia prática, mentoria humana.',
      paragraphs: [
        'Sou engenheiro mobile desde 2017, construindo e liderando produtos em escala — apps com 35M+ usuários '
            'e 100M+ downloads — como engenheiro sênior e tech lead. Hoje trabalho com Flutter e o ecossistema '
            'VTEX na Kobe.',
        'Ensinar sempre fez parte do trabalho, não é um extra. Orientei desenvolvedores, conduzi workshops '
            'internos, palestrei em GDGs e escrevo sobre mobile há anos. Minha abordagem é simples: menos teoria '
            'abstrata, mais código, decisões de arquitetura e um próximo passo concreto.',
      ],
      currentlyLabel: 'Hoje',
      currentlyRole: 'Engenheiro Mobile Sênior',
      currentlyCompany: 'Kobe',
      currentlyPeriod: 'Set 2026 — Atual',
    ),
    mentoring: MentoringContent(
      eyebrow: 'Mentoria 1:1',
      heading: 'Orientação de quem já percorreu o caminho.',
      lede:
          'Algumas vagas 1:1 abertas para desenvolvedores que querem crescer mais rápido do que conseguiriam '
          'sozinhos — unindo quase uma década de mobile em produção e mentoria prática de times Android e '
          'Kotlin Multiplatform.',
      forYouTitle: 'Para quem é',
      forYou: [
        'Desenvolvedores plenos que buscam o próximo nível, o sênior.',
        'Sêniores assumindo liderança técnica e querendo um framework para liderar times.',
        'Desenvolvedores Android e Flutter migrando para Kotlin Multiplatform.',
        'Quem está se preparando para processos seletivos internacionais.',
      ],
      forYouNote: 'Não sabe se é para você?',
      forYouNoteCta: 'Comece pela conversa gratuita',
      focusTitle: 'No que podemos trabalhar',
      focusAreas: [
        FocusArea(
          'Carreira',
          'A transição para sênior e tech lead, planos de crescimento, posicionamento e portfólio.',
        ),
        FocusArea(
          'Android & KMP',
          'Compose Multiplatform, arquitetura multi-módulo e integrações específicas para iOS e Android.',
        ),
        FocusArea(
          'Arquitetura & qualidade',
          'MVVM/MVI, modularização, estratégia de testes, Detekt e regras de arquitetura.',
        ),
        FocusArea(
          'Entrevistas internacionais',
          'Preparação técnica, mobile system design e inglês técnico.',
        ),
        FocusArea(
          'IA no fluxo de trabalho',
          'Claude Code, agentes e desenvolvimento assistido por IA, com revisão crítica do que é gerado.',
        ),
        FocusArea(
          'Open source & conteúdo',
          'Publicar e manter bibliotecas, construir um portfólio público e criar conteúdo técnico.',
        ),
      ],
      stepsTitle: 'Como funciona',
      steps: [
        MentorStep(
          'Você escreve',
          'Um e-mail curto com seu objetivo e o contexto em que você está hoje.',
        ),
        MentorStep(
          'Conversa de introdução · 30 min',
          'Alinhamos expectativas, verificamos o fit e definimos o foco.',
        ),
        MentorStep(
          'Sessões 1:1 · 1h',
          'Online, em português ou inglês, com um plano de ação claro entre os encontros.',
        ),
      ],
      stepsNote: 'Investimento e formato são combinados na conversa de introdução, de acordo com o seu objetivo.',
      getTitle: 'O que você leva',
      getItems: [
        'Um plano de desenvolvimento personalizado, com próximos passos concretos.',
        'Revisão de código e de arquitetura dos seus projetos.',
        'Materiais, referências e exercícios direcionados ao seu objetivo.',
        'Suporte assíncrono por e-mail entre as sessões.',
      ],
      ctaTitle: 'A primeira conversa é gratuita.',
      ctaText: 'Me conte onde você está e onde quer chegar. Vamos definir o próximo passo juntos.',
      ctaButton: 'Agendar minha conversa',
    ),
    experience: ExperienceContent(
      eyebrow: 'Experiência',
      heading: 'Quase uma década construindo produtos mobile.',
      lede: 'Experiências recentes. Histórico completo no LinkedIn.',
      roles: [
        Role(
          company: 'Kobe',
          title: 'Engenheiro Mobile Sênior',
          period: 'Set 2026 — Atual',
          bullets: [
            'Construção e evolução de apps de e-commerce com Flutter e Dart, em todo o ciclo do produto.',
            'Arquitetura, práticas de engenharia e testes automatizados para uma entrega escalável e com qualidade.',
            'Integração com o ecossistema VTEX e apoio à liderança técnica, code reviews e mentoria.',
          ],
        ),
        Role(
          company: 'Ambush',
          title: 'Engenheiro Mobile Sênior',
          period: 'Nov 2023 — Ago 2026',
          bullets: [
            'Features centrais de um app de cashback com 35M+ usuários e milhões de transações diárias.',
            'Liderança na adoção de Kotlin Multiplatform (Compose Multiplatform) e mentoria de desenvolvedores mobile.',
            'Feature flags, CI/CD com lint e testes de UI em Maestro, e padrões de arquitetura para o time.',
          ],
        ),
        Role(
          company: 'TELUS Digital',
          title: 'Engenheiro Android Sênior',
          period: 'Jul 2023 — Nov 2023',
          bullets: [
            'Features Android para um app de operadora com 25M–35M+ usuários ativos e 100M+ downloads.',
            'Mentoria de desenvolvedores Android e features complexas com Hilt, Jetpack Compose e projetos multi-módulo.',
          ],
        ),
        Role(
          company: 'Socialive',
          title: 'Engenheiro Android Sênior',
          period: 'Jul 2021 — Jun 2023',
          bullets: [
            'Features centrais de um app corporativo de gravação e transmissão de vídeo ao vivo.',
            'Gravação local em HD, captura de baixa latência e um display dinâmico com vários participantes.',
            'WebRTC, Dagger e Jetpack Components em um produto em produção.',
          ],
        ),
      ],
      linkLabel: 'Histórico completo no LinkedIn',
    ),
    toolkit: ToolkitContent(
      eyebrow: 'Ferramentas',
      heading: 'Ferramentas que uso.',
      groups: [
        SkillGroup(
          'Plataformas',
          'Android, Kotlin Multiplatform, Compose Multiplatform, Jetpack Compose, Flutter, Dart',
        ),
        SkillGroup('Arquitetura', 'MVVM, MVI, arquitetura multi-módulo, SOLID, programação reativa'),
        SkillGroup('Bibliotecas', 'Koin, Ktor, Coroutines, Room, Coil, GetX, MobX'),
        SkillGroup('Qualidade', 'Testes unitários e de UI, Maestro, Paparazzi, Detekt, validação de arquitetura'),
        SkillGroup('Entrega', 'Gradle, GitHub Actions, Fastlane, Danger, desenvolvimento de CLI, BuildKonfig'),
        SkillGroup('IA no dia a dia', 'Claude Code, Open Code, desenvolvimento agêntico'),
      ],
    ),
    work: WorkContent(
      eyebrow: 'Projetos',
      heading: 'Open source em que desenvolvedores confiam.',
      lede: 'Bibliotecas e ferramentas que criei e mantenho.',
      projects: [
        Project(
          name: 'Popcorn Guineapig',
          description:
              'Um conjunto leve de ferramentas que automatiza e aplica diretrizes de arquitetura em projetos '
              'Kotlin e Android multi-módulo.',
          tags: ['Kotlin', 'Detekt', 'Maven Central'],
          url: 'https://github.com/CodandoTV/popcorn-guineapig',
          linkLabel: 'Ver no GitHub',
        ),
        Project(
          name: 'JujubaSVG',
          description:
              'Manipulação granular de SVG — incluindo propriedades por ID — para Compose Multiplatform, '
              'Android e Flutter.',
          tags: ['Kotlin', 'Dart', 'Maven Central', 'pub.dev'],
          url: 'https://github.com/CodandoTV/jujubaSVG',
          linkLabel: 'Ver no GitHub',
        ),
        Project(
          name: 'EagleEye',
          description:
              'Uma CLI em Dart que detecta violações de arquitetura e dependências proibidas em projetos '
              'Flutter e Dart.',
          tags: ['Dart', 'CLI', 'pub.dev'],
          url: 'https://github.com/CodandoTV/eagle-eye',
          linkLabel: 'Ver no GitHub',
        ),
        Project(
          name: 'MovieDB-App',
          description:
              'App de referência em Compose Multiplatform e Kotlin Multiplatform, selecionado para o Google '
              'Dev Library.',
          tags: ['KMP', 'Compose', 'Dev Library'],
          url: 'https://github.com/gabrielbmoro/MovieDB-App',
          linkLabel: 'Ver no GitHub',
        ),
      ],
    ),
    community: CommunityContent(
      eyebrow: 'Comunidade',
      heading: 'Compartilhando o que aprendo.',
      items: [
        CommunityItem(
          label: 'Palestras',
          description: 'GDG Groups e GDG DevFest — desenvolvimento mobile, arquitetura e Kotlin para a comunidade.',
        ),
        CommunityItem(
          label: 'Artigos',
          description: 'Code review, navegação e testes no Medium.',
          links: [LinkRef('Ler no Medium', _mediumUrl)],
        ),
        CommunityItem(
          label: 'CodandoTV',
          description: 'Vídeos técnicos, bibliotecas open source e um podcast para a comunidade brasileira.',
          links: [
            LinkRef('Assistir no YouTube', _youTubeUrl),
            LinkRef('codandotv.com', _codandoTvUrl),
          ],
        ),
        CommunityItem(
          label: 'Koin Champion',
          description: 'Reconhecido pela Kotzilla por artigos técnicos e casos reais de uso do Koin.',
          links: [LinkRef('Kotzilla', _koinChampionUrl)],
        ),
      ],
    ),
    footer: FooterContent(
      heading: 'Vamos encontrar o seu próximo passo.',
      text:
          'Se você está pronto para crescer para o próximo papel, quero ajudar. Me mande uma mensagem curta '
          'e começamos por aí.',
      cta: 'Enviar um e-mail',
      availability: 'Aberto para mentorias 1:1',
      copyright: '© 2026 Gabriel Bronzatti Moro',
      builtWith: 'Feito com Jaspr · Hospedado no GitHub Pages',
      links: [
        LinkRef('LinkedIn', _linkedInUrl),
        LinkRef('GitHub', _gitHubUrl),
        LinkRef('Medium', _mediumUrl),
        LinkRef('YouTube', _youTubeUrl),
      ],
    ),
  );

  @override
  List<SiteContent> get contents => const [_en, _ptBr];

  @override
  SiteContent contentFor(String lang) => switch (lang) {
    'en' => _en,
    'pt-BR' => _ptBr,
    _ => throw ArgumentError.value(lang, 'lang', 'Unknown site locale'),
  };
}
