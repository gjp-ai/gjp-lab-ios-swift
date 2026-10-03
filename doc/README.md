# GJPLab iOS documentation

This directory documents the iOS lab as it exists today and the behavior it is intended to provide. Source code remains authoritative for implementation; requirement documents are authoritative for intended product behavior.

## Layout

- `architecture/` holds project-wide documents that describe the whole app.
- `specs/` mirrors `GJPLab/` exactly: the docs for `GJPLab/<path>/` live in `doc/specs/<path>/`.
- `templates/` holds the starting point for new requirement and detail design documents.
- `decisions/` records project choices the code alone does not explain, and why they were made.

```
doc/
├── architecture/application.md           project-wide
├── decisions/                            0001-….md, one per decision
├── templates/                            requirement.md, detail_design.md
└── specs/                                mirrors GJPLab/
    ├── app/startup/                      ↔ GJPLab/app/startup/
    │   ├── splash_requirement.md / splash_detail_design.md
    │   └── maintenance_requirement.md / maintenance_detail_design.md
    ├── app/navigation/                   ↔ GJPLab/app/navigation/
    │   ├── sidebar_requirement.md / sidebar_detail_design.md
    │   └── catalog_requirement.md / catalog_detail_design.md
    ├── common/theme/                     ↔ GJPLab/common/theme/
    │   └── theme_detail_design.md        (Slate design system)
    └── features/                         ↔ GJPLab/features/
        └── <category>/<feature>/
            ├── <feature>_requirement.md
            └── <feature>_detail_design.md
```

The `GJPLab/app/` root files are documented in [application architecture](architecture/application.md). `GJPLab/common/config/` holds only constants and has no spec.

`<feature>` is the code folder name (for example `urlsession`, `blockappduringcalls`). Every screen has both a requirement and a detail design; add them together, starting from [`templates/`](templates/). Shared code with no user-facing behavior, such as `common/theme/`, has a detail design only.

## Document map

| Area | Requirement | Detailed design |
| --- | --- | --- |
| Agent contract | [`AGENTS.md`](../AGENTS.md): project rules, commands, and skill routing | — |
| Application structure | — | [Application architecture](architecture/application.md) |
| Visual system | — | [Slate design system](specs/common/theme/theme_detail_design.md) |
| Decisions | [Decision records](decisions/README.md): why the project is shaped the way it is | — |
| Splash (startup) | [Splash requirement](specs/app/startup/splash_requirement.md) | [Splash detailed design](specs/app/startup/splash_detail_design.md) |
| Maintenance (startup) | [Maintenance requirement](specs/app/startup/maintenance_requirement.md) | [Maintenance detailed design](specs/app/startup/maintenance_detail_design.md) |
| Category sidebar | [Sidebar requirement](specs/app/navigation/sidebar_requirement.md) | [Sidebar detailed design](specs/app/navigation/sidebar_detail_design.md) |
| Category catalogue | [Catalogue requirement](specs/app/navigation/catalog_requirement.md) | [Catalogue detailed design](specs/app/navigation/catalog_detail_design.md) |
| HTTP Client → URLSession | [URLSession requirement](specs/features/httpclient/urlsession/urlsession_requirement.md) | [URLSession detailed design](specs/features/httpclient/urlsession/urlsession_detail_design.md) |
| Security → Block App During Calls | [Requirement](specs/features/security/blockappduringcalls/blockappduringcalls_requirement.md) | [Detailed design](specs/features/security/blockappduringcalls/blockappduringcalls_detail_design.md) |
| Integration → Firebase | [Firebase lab requirement](specs/features/integration/firebase/firebase_requirement.md) | [Firebase detailed design](specs/features/integration/firebase/firebase_detail_design.md) |
| Others → OS & hardware | [Requirement](specs/features/others/deviceinfo/deviceinfo_requirement.md) | [Detailed design](specs/features/others/deviceinfo/deviceinfo_detail_design.md) |
| New features | [Requirement template](templates/requirement.md) | [Detail design template](templates/detail_design.md) |

## Reading paths

- **New contributor:** application architecture → feature or integration guide → related Swift sources.
- **Product or QA:** requirements → acceptance scenarios → implementation status in the detailed design.
- **iOS implementation agent:** [`AGENTS.md`](../AGENTS.md) → selected skill → relevant design and requirement documents.

## Documentation contract

Each fact has one owner:

- Requirements describe observable behavior and avoid prescribing SwiftUI types.
- Detailed designs explain how the current iOS implementation satisfies—or does not yet satisfy—requirements.
- Architecture documents stable project-wide boundaries and links to feature details instead of duplicating them.
- Integration guides document external-service behavior, configuration, and operational risks.

Use repository-relative links and short symbol references rather than copied implementations.

## Status language

| Label | Meaning |
| --- | --- |
| Implemented | Present in source and verifiable from the repository |
| Partial | Some required behavior exists, with named gaps |
| Planned | Approved requirement with no complete implementation yet |
| Open | Requires product, design, security, or architecture input |

## Maintenance

New feature docs start from the [requirement template](templates/requirement.md) and the [detail design template](templates/detail_design.md), and live at `specs/features/<category>/<feature>/<feature>_requirement.md`, next to `<feature>_detail_design.md`. When a change reverses or adds a project-wide choice, add a [decision record](decisions/README.md). Add a detailed design before or alongside implementation when a feature has lifecycle, persistence, integration, platform, or security behavior.

Update this documentation in the same change when user-visible behavior, routes, state ownership, entitlements, Info.plist permissions, Firebase contracts, build/test commands, the toolchain or deployment target, or material limitations change. Before handoff, verify local Markdown links and report checks that could not run.
