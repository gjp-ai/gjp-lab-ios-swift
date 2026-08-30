# GJPLab iOS documentation

This directory documents the iOS lab as it exists today, the behavior it is intended to provide, and the reusable engineering practices exercised here. Source code remains authoritative for implementation; requirement documents are authoritative for intended product behavior.

## Document map

| Area | Canonical document | Purpose |
| --- | --- | --- |
| Application structure | [Application architecture](architecture/application.md) | Runtime flow, code boundaries, state ownership, and project constraints |
| Visual system | [Slate design system](architecture/design-system.md) | SwiftUI semantic colors, app icon, launch screen, dark mode, and usage rules |
| Splash behavior | [Splash requirements](requirements/splash-screen.md) | Product rules, acceptance criteria, and open decisions |
| Splash implementation | [Splash technical design](features/splash-screen.md) | Current SwiftUI design, concurrency behavior, known gaps, and test strategy |
| Firebase | [Firebase integration](integrations/firebase.md) | SDK wiring, service behavior, privacy notes, and verification |
| AI-assisted iOS practice | [iOS agent skills](practices/ios-agent-skills.md) | How this repository exercises and improves the portable skill library |

## Reading paths

- **New contributor:** application architecture → feature or integration guide → related Swift sources.
- **Product or QA:** requirements → acceptance scenarios → implementation status in the technical design.
- **iOS implementation agent:** [`AGENTS.md`](../AGENTS.md) → selected skill → relevant design and requirement documents.
- **Skill improvement:** iOS agent-skills practice → a real repository task → evidence-based skill revision.

## Documentation contract

Each fact has one owner:

- Requirements describe observable behavior and avoid prescribing SwiftUI types.
- Feature designs explain how the current iOS implementation satisfies—or does not yet satisfy—requirements.
- Architecture documents stable project-wide boundaries and links to feature details instead of duplicating them.
- Integration guides document external-service behavior, configuration, and operational risks.
- Practice guides describe repeatable learning workflows, not product requirements.

Use repository-relative links and short symbol references rather than copied implementations.

## Status language

| Label | Meaning |
| --- | --- |
| Implemented | Present in source and verifiable from the repository |
| Partial | Some required behavior exists, with named gaps |
| Planned | Approved requirement with no complete implementation yet |
| Open | Requires product, design, security, or architecture input |

## Maintenance

Update this documentation in the same change when user-visible behavior, routes, state ownership, entitlements, Info.plist permissions, Firebase contracts, build/test commands, or material limitations change. Before handoff, verify local Markdown links and report checks that could not run.
