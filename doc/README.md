# GJPLab iOS documentation

This directory documents the iOS lab as it exists today and the behavior it is intended to provide. Source code remains authoritative for implementation; requirement documents are authoritative for intended product behavior.

## Layout

`doc/` has two kinds of documents:

- `architecture/` holds project-wide documents that describe the whole app.
- `specs/` mirrors `GJPLab/` exactly: the docs for `GJPLab/<path>/` live in `doc/specs/<path>/`.

```
doc/
├── architecture/                         project-wide
│   ├── application.md
│   └── design-system.md
└── specs/                                mirrors GJPLab/
    ├── app/startup/                      ↔ GJPLab/app/startup/
    │   ├── splash_requirement.md / splash_detail_design.md
    │   └── maintenance_requirement.md / maintenance_detail_design.md
    ├── navigation/                       ↔ GJPLab/navigation/
    │   ├── dashboard/dashboard_requirement.md / dashboard_detail_design.md
    │   └── catalog/catalog_requirement.md / catalog_detail_design.md
    └── features/                         ↔ GJPLab/features/
        ├── feature_requirement_template.md
        └── <category>/<feature>/
            ├── <feature>_requirement.md
            └── <feature>_detail_design.md
```

Shared code is documented project-wide rather than mirrored: `GJPLab/app/` root files in [application architecture](architecture/application.md), `GJPLab/common/` in the [design system](architecture/design-system.md), and `GJPLab/sdk/` in the [Firebase detailed design](specs/features/integration/firebase/firebase_detail_design.md).

`<feature>` is the code folder name (for example `urlsession`, `blockappduringcalls`). Every mirrored folder has both files; add them together when you add a screen.

## Document map

| Area | Requirement | Detailed design |
| --- | --- | --- |
| Agent contract | [`AGENTS.md`](../AGENTS.md): project rules, commands, and skill routing | — |
| Application structure | — | [Application architecture](architecture/application.md) |
| Visual system | — | [Slate design system](architecture/design-system.md) |
| Splash (startup) | [Splash requirement](specs/app/startup/splash_requirement.md) | [Splash detailed design](specs/app/startup/splash_detail_design.md) |
| Maintenance (startup) | [Maintenance requirement](specs/app/startup/maintenance_requirement.md) | [Maintenance detailed design](specs/app/startup/maintenance_detail_design.md) |
| Dashboard | [Dashboard requirement](specs/navigation/dashboard/dashboard_requirement.md) | [Dashboard detailed design](specs/navigation/dashboard/dashboard_detail_design.md) |
| Category catalogue | [Catalogue requirement](specs/navigation/catalog/catalog_requirement.md) | [Catalogue detailed design](specs/navigation/catalog/catalog_detail_design.md) |
| HTTP Client → URLSession | [URLSession requirement](specs/features/httpclient/urlsession/urlsession_requirement.md) | [URLSession detailed design](specs/features/httpclient/urlsession/urlsession_detail_design.md) |
| Security → Block App During Calls | [Requirement](specs/features/security/blockappduringcalls/blockappduringcalls_requirement.md) | [Detailed design](specs/features/security/blockappduringcalls/blockappduringcalls_detail_design.md) |
| Integration → Firebase | [Firebase lab requirement](specs/features/integration/firebase/firebase_requirement.md) | [Firebase detailed design](specs/features/integration/firebase/firebase_detail_design.md) |
| Others → OS & hardware | [Requirement](specs/features/others/deviceinfo/deviceinfo_requirement.md) | [Detailed design](specs/features/others/deviceinfo/deviceinfo_detail_design.md) |
| New features | [Feature requirement template](specs/features/feature_requirement_template.md) | — |

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

New feature requirements must start from the [feature requirement template](specs/features/feature_requirement_template.md) and live at `specs/features/<category>/<feature>/<feature>_requirement.md`, next to `<feature>_detail_design.md`. Add a detailed design before or alongside implementation when a feature has lifecycle, persistence, integration, platform, or security behavior.

Update this documentation in the same change when user-visible behavior, routes, state ownership, entitlements, Info.plist permissions, Firebase contracts, build/test commands, the toolchain or deployment target, or material limitations change. Before handoff, verify local Markdown links and report checks that could not run.
