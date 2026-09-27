# GJPLab iOS documentation

This directory documents the iOS lab as it exists today and the behavior it is intended to provide. Source code remains authoritative for implementation; requirement documents are authoritative for intended product behavior.

## Layout

Doc folders mirror the code folders under `GJPLab/`, so a feature's docs sit at the same path as its source.

```
doc/
├── architecture/                     project-wide structure and design system
├── app/startup/                      ↔ GJPLab/app/startup/
│   ├── splash_requirement.md
│   └── splash_detail_design.md
└── features/                         ↔ GJPLab/features/
    ├── feature_requirement_template.md
    └── <category>/<feature>/
        ├── <feature>_requirement.md
        └── <feature>_detail_design.md
```

`<feature>` is the code folder name (for example `urlsession`, `blockappduringcalls`). A feature may have only one of the two files; an integration guide takes the detailed-design name.

## Document map

| Area | Requirement | Detailed design |
| --- | --- | --- |
| Agent contract | [`AGENTS.md`](../AGENTS.md): project rules, commands, and skill routing | — |
| Application structure | — | [Application architecture](architecture/application.md) |
| Visual system | — | [Slate design system](architecture/design-system.md) |
| Splash (startup) | [Splash requirement](app/startup/splash_requirement.md) | [Splash detailed design](app/startup/splash_detail_design.md) |
| HTTP Client → URLSession | [URLSession requirement](features/httpclient/urlsession/urlsession_requirement.md) | [URLSession detailed design](features/httpclient/urlsession/urlsession_detail_design.md) |
| Security → Block App During Calls | [Requirement](features/security/blockappduringcalls/blockappduringcalls_requirement.md) | [Detailed design](features/security/blockappduringcalls/blockappduringcalls_detail_design.md) |
| Integration → Firebase | — | [Firebase detailed design](features/integration/firebase/firebase_detail_design.md) |
| New features | [Feature requirement template](features/feature_requirement_template.md) | — |

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

New feature requirements must start from the [feature requirement template](features/feature_requirement_template.md) and live at `features/<category>/<feature>/<feature>_requirement.md`, next to `<feature>_detail_design.md`. Add a detailed design before or alongside implementation when a feature has lifecycle, persistence, integration, platform, or security behavior.

Update this documentation in the same change when user-visible behavior, routes, state ownership, entitlements, Info.plist permissions, Firebase contracts, build/test commands, the toolchain or deployment target, or material limitations change. Before handoff, verify local Markdown links and report checks that could not run.
