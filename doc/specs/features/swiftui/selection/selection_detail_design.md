# Selection detailed design

Status: Implemented, with known gaps

Requirements: [Selection](selection_requirement.md)

## Implementation goal

A sample coffee order in a `Form`: each control binds to one `@State` property, and a summary section reads them all, which shows selection state flowing into derived UI.

## Source map

| Source | Responsibility |
| --- | --- |
| [`SelectionScreen.swift`](../../../../../GJPLab/features/swiftui/selection/SelectionScreen.swift) | Form, `binding(for:)`, `extrasSummary`, private `CoffeeSize`, `Milk`, `Extra`, `SectionHeader`, `Footer` |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.selection` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "selection"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.selection` to the screen in `feature(for:)` |

## Ownership and state

- `SelectionScreen` owns `size`, `milk`, `shots` (1–4), `sweetness` (0–1), `isIced`, `extras` (`Set<Extra>`), `pickup` (now + 15 minutes), and `cupColor` with `@State`.
- There is no repository: every value is local sample state, so the view owns it directly, as the architecture allows for screen state.

## Multi-selection binding

`binding(for:)` builds a `Binding<Bool>` whose getter is `extras.contains(extra)` and whose setter inserts or removes the extra. Each `Toggle` with `.toggleStyle(.button)` uses one such binding, so the `Set` is the single source of truth.

## Summary

`extrasSummary` filters `Extra.allCases` by membership (keeping a stable order, since a `Set` is unordered) and formats the names with `.formatted(.list(type: .and))`. The summary row is one accessibility element (`.combine`); its icon is hidden.

## Date range

`DatePicker(in: Date.now...)` disables past dates. The lower bound is taken when the body is evaluated, so it moves forward as the view updates.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| `cupColor` defaults to system gray, not a `LabTheme` role | A raw system colour appears in the sample | Acceptable for a user-chosen colour; or default to `LabTheme.onSurfaceVariant` |
| The initial pickup time can fall in the past if the screen stays open | The date picker shows an out-of-range value | Clamp `pickup` in `.onAppear` or on change |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: SEL-AC-01 to SEL-AC-03 on an iPhone simulator in light and dark appearance.
