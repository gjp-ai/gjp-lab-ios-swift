---
name: ios-architecture
description: Design, implement, migrate, or review iOS feature architecture, including SwiftUI state ownership, @Observable models, view models, navigation and NavigationStack routes, deep links, lifecycle, dependency injection, and modularization with Swift packages. Use for end-to-end features, adding a screen with navigation, choosing where state lives, restructuring or modularizing code, or architecture reviews. Not for styling-only or data-source-only work.
metadata:
  version: "0.3.0"
---

# iOS Feature Architecture

Build features that fit the host app and make state ownership, effects, navigation, and lifecycle explicit. Do not impose a preferred architecture because it is common elsewhere.

Pairs with `ios-swiftui-patterns` for the UI, `ios-data-layer` for data sources, and `swift-concurrency` for isolation.

## Discover the host project

Read project instructions, the closest feature, the app entry point, route definitions, observable state owners, dependency construction, lifecycle handling, and tests. Identify the outcome, sources of truth, event paths, restoration needs, and contracts that must stay compatible. Keep established patterns unless a concrete limitation or an explicit request requires change; add layers only for a demonstrated need.

## Select a mode

- **Build or extend a feature:** [feature workflow](references/feature-workflow.md).
- **Migrate architecture:** [migration guide](references/migration.md), only for an explicit request or an unmet requirement.
- **Split into packages or modules:** [modularization guide](references/modularization.md).
- **Review architecture:** [review checklist](references/review.md); report without editing unless asked.

## Gotchas

- Match the ownership wrapper to the model: `@Observable` is owned with `@State`, passed as a plain property, bound with `@Bindable`, and shared with `.environment(_:)`. `ObservableObject` is owned with `@StateObject` and borrowed with `@ObservedObject`. `@State` holding an `ObservableObject` never refreshes the view.
- `@State` and `@StateObject` keep their first value for a view's identity; later init arguments do not reset them. Reset deliberately with `.id(_:)` or `onChange`.
- Register `navigationDestination(for:)` on a view that is always in the stack, not inside lazy containers or conditional content.
- Make routes `Hashable` values that carry IDs, not live models; add `Codable` when paths must be restored.
- Translate URLs and notifications into routes at one app boundary, such as `onOpenURL` or the app delegate, then update the path.

## Completion contract

- Give each mutable value one owner and expose stable state at boundaries.
- Separate persistent view state from one-time effects such as navigation, alerts, and permission prompts.
- Preserve navigation-path, restoration, deep-link, scene-phase, and dependency-lifetime behavior.
- Keep boundaries proportional to the app; avoid pass-through layers.
- Verify the smallest affected build and tests, then report unverified lifecycle or navigation risk.
