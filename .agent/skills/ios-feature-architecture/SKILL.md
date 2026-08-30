---
name: ios-feature-architecture
description: Design, implement, migrate, or review iOS feature architecture, including SwiftUI state, navigation, lifecycle, dependency ownership, deep links, and module boundaries. Use for end-to-end features or state/navigation changes, not styling-only or data-source-only work.
metadata:
  version: "0.1.0"
---

# iOS Feature Architecture

Build a feature that fits the host app and makes state ownership, effects, navigation, and lifecycle behavior explicit. Do not impose a preferred architecture merely because it is common elsewhere.

## Discover the host project

Before architecture changes, read project instructions, the closest feature, app entry point, route definitions, observable state owners, dependency construction, lifecycle handling, and tests. Identify the outcome, sources of truth, event paths, restoration requirements, and contracts that must remain compatible.

Preserve established patterns unless a concrete limitation or explicit migration request requires change. Add layers or dependencies only when they solve that demonstrated need.

## Select a mode

- **Build or extend a feature:** Read [the feature workflow](references/feature-workflow.md).
- **Migrate architecture:** Read [the migration guide](references/migration.md) only for an explicit migration or an unmet requirement.
- **Review architecture:** Read [the review guide](references/review.md); report findings without editing unless asked.

## Completion contract

- Give each mutable value one clear owner and expose stable state at boundaries.
- Distinguish persistent view state from one-time effects such as navigation, alerts, and permission prompts.
- Preserve relevant navigation-path, restoration, deep-link, scene-phase, and dependency-lifetime behavior.
- Keep feature, UI, and data boundaries proportional to the app; avoid pass-through abstraction.
- Verify the smallest affected build and tests, then report unverified lifecycle or navigation risk.
