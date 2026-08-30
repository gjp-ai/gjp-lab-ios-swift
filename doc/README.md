# GJPLab iOS documentation

This directory documents the iOS lab as it exists today, the behavior it is intended to provide, and the reusable engineering practices exercised here. Source code remains authoritative for implementation; requirement documents are authoritative for intended product behavior.

## Document map

| Area | Canonical document | Purpose |
| --- | --- | --- |
| Application structure | [Application architecture](architecture/application.md) | Runtime flow, code boundaries, state ownership, and project constraints |
| Visual system | [Slate design system](architecture/design-system.md) | SwiftUI semantic colors, app icon, launch screen, dark mode, and usage rules |
| Requirement template | [Feature requirement template](requirements/FEATURE_REQUIREMENT_TEMPLATE.md) | Required structure for new feature requirements |
| Splash behavior | [Splash requirements](requirements/splash-screen.md) | Product rules and acceptance criteria |
| Call blocking behavior | [Block App During Calls requirements](requirements/security/block_app_during_calls.md) | Security feature behavior, China restriction, and acceptance criteria |
| Splash implementation | [Splash detailed design](detail-design/splash-screen.md) | Current SwiftUI design, concurrency behavior, known gaps, and test strategy |
| Call blocking implementation | [Block App During Calls detailed design](detail-design/security/block_app_during_calls.md) | Developer source map, lifecycle, state, platform safeguards, and verification |
| Firebase | [Firebase integration](integrations/firebase.md) | SDK wiring, service behavior, privacy notes, and verification |
| AI-assisted iOS practice | [iOS agent skills](practices/ios-agent-skills.md) | How this repository exercises and improves the portable skill library |

## Reading paths

- **New contributor:** application architecture → feature or integration guide → related Swift sources.
- **Product or QA:** requirements → acceptance scenarios → implementation status in the detailed design.
- **iOS implementation agent:** [`AGENTS.md`](../AGENTS.md) → selected skill → relevant design and requirement documents.
- **Skill improvement:** iOS agent-skills practice → a real repository task → evidence-based skill revision.

## Documentation contract

Each fact has one owner:

- Requirements describe observable behavior and avoid prescribing SwiftUI types.
- Detailed designs explain how the current iOS implementation satisfies—or does not yet satisfy—requirements.
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

New feature requirements must start from the [feature requirement template](requirements/FEATURE_REQUIREMENT_TEMPLATE.md). Add a detailed design before or alongside implementation when a feature has lifecycle, persistence, integration, platform, or security behavior.

Update this documentation in the same change when user-visible behavior, routes, state ownership, entitlements, Info.plist permissions, Firebase contracts, build/test commands, or material limitations change. Before handoff, verify local Markdown links and report checks that could not run.
