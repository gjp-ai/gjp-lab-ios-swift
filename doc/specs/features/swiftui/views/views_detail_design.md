# Views & modifiers detailed design

Status: Implemented, with known gaps

Requirements: [Views & modifiers](views_requirement.md)

## Implementation goal

One `LabDemoPage` with four `LabDemoSection` cards, each a live sample next to the code idea it shows. Reusable pieces (`OrderSample`, `TagView`, `CalloutModifier`) are private to the file so the topic stays self-contained.

## Source map

| Source | Responsibility |
| --- | --- |
| [`ViewsModifiersScreen.swift`](../../../../../GJPLab/features/swiftui/views/ViewsModifiersScreen.swift) | Screen, private `OrderSample`, `TagView`, `CalloutModifier`, and the `.callout(isHighlighted:)` extension |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.viewsModifiers` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "viewsModifiers"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.viewsModifiers` to the screen in `feature(for:)` |

## Ownership and state

- `ViewsModifiersScreen` owns `padding` (`Double`, default 12) and `isHighlighted` (`Bool`) with `@State`; both reset when the topic is reopened.
- Reached from `FeatureRoute.viewsModifiers`; pushes nothing.
- There is no repository: every value is local sample state, so the view owns it directly, as the architecture allows for screen state.

## Modifier order sample

Both samples receive the same `padding` value. *Padding first* applies `.padding` then `.background`, so the fill includes the padding; *Background first* applies them in reverse, so the padding is transparent space outside the fill. A thin `outlineVariant` border marks each sample's frame so the difference is visible.

## Generic views with @ViewBuilder

`OrderSample<Sample: View>` and `TagView<Label: View>` store a `@ViewBuilder let` property. Swift synthesises an initializer whose trailing closure builds the content, which is the same pattern `LabDemoSection` uses.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| `CalloutModifier` and `.callout` are private | Other screens cannot reuse the sample modifier | Keep private; promote to `common/theme/` only if a real screen needs it |
| No snapshot of the rendered order difference | A layout regression would go unnoticed | Add a snapshot test if a snapshot library is approved |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: VIEW-AC-01 to VIEW-AC-03 on an iPhone simulator in light and dark appearance.
