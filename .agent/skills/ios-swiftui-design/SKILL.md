---
name: ios-swiftui-design
description: Design, implement, refactor, or review iOS interfaces built with SwiftUI. Use for screens, themes, forms, UI states, navigation surfaces, accessibility, adaptive layouts, previews, and UI tests. Do not use for UIKit-only, backend-only, or architecture-only work.
metadata:
  version: "0.1.0"
---

# iOS SwiftUI Design

Produce an accessible, native SwiftUI result that fits the host app. Repository instructions and installed dependencies define architecture and APIs; this skill supplies a reusable UI workflow and quality bar.

## Discover the host project

Before editing UI, read project instructions, target deployment version, theme entry point, target view, state owner, navigation entry point, previews, and relevant tests. Identify the user outcome, reachable states, behavior that must remain unchanged, and supported iPhone/iPad window scope.

Use APIs available to the target. Preserve the host's state, navigation, and data boundaries unless the user explicitly requests an architectural change.

## Select a mode

- **Build or refactor:** Read [the SwiftUI workflow](references/swiftui-workflow.md).
- **Review or audit:** Read [the review guide](references/review.md); report evidence without editing unless asked.
- **Adaptive UI:** Also read [the adaptive-layout guide](references/adaptive.md) for iPad, split view, Stage Manager, dynamic type, or resizing work.
- **Practice or skill improvement:** Read [the practice guide](references/practice.md).

## Completion contract

- Keep rendering declarative: state flows down and user intent flows up through the project's established boundary.
- Use semantic colors, standard controls, and system behavior before custom replacements.
- Represent loading, empty, content, failure, disabled, and permission states only when the product can reach them.
- Verify VoiceOver labels, Dynamic Type, safe areas, light/dark appearance, and applicable window sizes in proportion to the change.
- Run the smallest relevant build and tests; report what was verified and any remaining risk.
