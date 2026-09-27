---
name: ios-swiftui-patterns
description: Design, implement, refactor, or review iOS interfaces built with SwiftUI, including UIKit interop. Use for screens, components, themes, dark mode, forms, lists, UI states, navigation surfaces, animations, accessibility and VoiceOver, Dynamic Type, localization and String Catalogs, iPad and adaptive layouts, Liquid Glass, previews, and UI tests, or when embedding UIKit views (UIViewRepresentable, UIHostingController). Not for backend, data-only, or architecture-only work.
metadata:
  version: "0.3.0"
---

# iOS SwiftUI Design

Produce an accessible, native SwiftUI result that fits the host app. Project instructions and installed dependencies define architecture and APIs; this skill supplies the UI workflow and quality bar.

Pairs with `ios-architecture` for state and navigation, `ios-testing` for UI tests, and `ios-api-availability` for OS-version gating.

## Discover the host project

Read project instructions, deployment target, theme entry point, the target view, its state owner and navigation entry, previews, and relevant tests. Identify the user outcome, reachable states, behavior that must not change, and supported iPhone and iPad window sizes. Use only APIs available to the deployment target, and keep the host's state, navigation, and data boundaries unless asked to change them.

## Select a mode

- **Build or refactor:** [SwiftUI workflow](references/swiftui-workflow.md).
- **Review or audit:** [review checklist](references/review.md); report without editing unless asked.
- **iPad, split view, resizing, or rotation:** also [adaptive-layout guide](references/adaptive.md).
- **User-facing text, plurals, formatting, or right-to-left:** also [localization guide](references/localization.md).
- **UIKit in SwiftUI or SwiftUI in UIKit:** [UIKit interop guide](references/uikit-interop.md).

## Gotchas

- Tie async work to view lifetime with `.task` or `.task(id:)`; `onAppear { Task { … } }` keeps running after the view disappears.
- Identity drives state: `ForEach` needs stable, unique IDs (not array indices for mutable lists, not `\.self` on duplicates). Changing `.id(_:)`, switching `if` branches, or `AnyView` resets state and animations.
- `Text("literal")` is localized; `Text(stringVariable)` is not. Use leading and trailing, never left and right.
- `accessibilityIdentifier` is for UI tests only; VoiceOver reads `accessibilityLabel`. Icon-only buttons need a label.
- Use `@Previewable @State` for interactive previews; previews must not call live services.
- From the iOS 26 SDK, standard bars, controls, and sheets adopt Liquid Glass automatically. Remove custom backgrounds that fight it before adding `glassEffect`, and gate newer APIs as described in `ios-api-availability`.

## Completion contract

- State flows down and user intent flows up through the project's established boundary.
- Use semantic colors, standard controls, and system behavior before custom replacements.
- Represent loading, empty, content, failure, disabled, and permission states only when the product can reach them.
- Verify VoiceOver labels, Dynamic Type, safe areas, light and dark appearance, and applicable window sizes in proportion to the change.
- Run the smallest relevant build and tests; report what was verified and any remaining risk.
