# Navigation detailed design

Status: Implemented, with known gaps

Requirements: [Navigation](navigation_requirement.md)

## Implementation goal

Pushes reuse the detail column's `NavigationStack(path:)` owned by `ContentView` through a new `DetailRoute.navigationLevel(Int)`; all other patterns are presentations driven by local Bool state, so no extra navigation stack is added.

## Source map

| Source | Responsibility |
| --- | --- |
| [`NavigationPatternsScreen.swift`](../../../../../GJPLab/features/swiftui/navigation/NavigationPatternsScreen.swift) | Topic root, toolbar button, inspector, sheet, cover, popover, private `PresentationContent` |
| [`NavigationLevelScreen.swift`](../../../../../GJPLab/features/swiftui/navigation/NavigationLevelScreen.swift) | Pushed level: push deeper, back one level, pop to root |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.navigationPatterns` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "navigationPatterns"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.navigationPatterns` to the screen in `feature(for:)` |

## Ownership and state

- `NavigationPatternsScreen` owns `isShowingSheet`, `isShowingCover`, `isShowingPopover`, and `isShowingInspector` with `@State`.
- `ContentView` owns the path (`detailPath: [DetailRoute]`). Its `navigationDestination(for: DetailRoute.self)` maps `.navigationLevel(level)` to `NavigationLevelScreen(level:onPopToRoot:)`, passing `{ detailPath = [] }`.
- `ContentView` already clears `detailPath` when the selected topic changes, so a deep stack never leaks into another topic.

## Push flow

`NavigationLink(value: DetailRoute.navigationLevel(n))` appends to the bound path; SwiftUI then asks `navigationDestination` for the view. `NavigationLevelScreen` pops one level with `@Environment(\.dismiss)` and pops to root through the `onPopToRoot` closure, because only `ContentView` may change the path (state flows down, intent flows up).

## Presentations

`PresentationContent` closes itself with `dismiss`, so presenters only own a Bool. The sheet uses `.presentationDetents([.medium, .large])` and a visible drag indicator. The popover uses `.presentationCompactAdaptation(.popover)` so it stays a popover on iPhone. The inspector is attached to the topic root with `.inspector(isPresented:)` and a column width of 240–400 points; on iPhone the system shows it as a sheet. `.navigationTitle` and `.toolbar` are applied *after* `.inspector`: on iPhone the inspector wraps the screen in a container, and a title or toolbar set inside it (for example by `LabDemoPage`) is dropped, leaving a blank title and no Inspector button.

## Why no NavigationStack in presentations

The project allows only `ContentView`'s navigation structure. Presented content therefore has no navigation bar; it shows its own title and a close button.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Pushed levels have no limit | Very deep stacks are possible | Acceptable for a sample; cap the level if needed |
| Deep links are explained but not implemented | The requirement's catalogue description mentions deep links | Add a URL scheme and `onOpenURL` mapping to `FeatureRoute` when deep links become a requirement |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: NAV-AC-01 to NAV-AC-04 on an iPhone simulator, and the inspector and popover on an iPad simulator.
