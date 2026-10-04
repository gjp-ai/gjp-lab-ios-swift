# Layouts detailed design

Status: Implemented, with known gaps

Requirements: [Layouts](layouts_requirement.md)

## Implementation goal

Switch stack types with `AnyLayout` so the same three children animate between arrangements, and implement wrapping with a custom `Layout` whose arithmetic is a pure static function.

## Source map

| Source | Responsibility |
| --- | --- |
| [`LayoutsScreen.swift`](../../../../../GJPLab/features/swiftui/layouts/LayoutsScreen.swift) | Screen, private `StackKind` (title and `AnyLayout` factory) and `NumberedBox` |
| [`FlowLayout.swift`](../../../../../GJPLab/features/swiftui/layouts/FlowLayout.swift) | Custom `Layout` and the pure `arrange(sizes:maxWidth:spacing:)` |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.layouts` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "layouts"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.layouts` to the screen in `feature(for:)` |

## Ownership and state

- `LayoutsScreen` owns `stack` (`StackKind`), `spacing` (0–40, default 12), and `fitWidth` (140–320, default 320) with `@State`.
- `FlowLayout` has no cache (`Cache == Void`); it measures subviews in both `sizeThatFits` and `placeSubviews`, which is cheap for a handful of tags.
- There is no repository: every value is local sample state, so the view owns it directly, as the architecture allows for screen state.

## AnyLayout

`StackKind.layout(spacing:)` returns `AnyLayout(HStackLayout)`, `VStackLayout`, or `ZStackLayout`. Because the container type is erased but the children keep their identity, `.animation(.spring, value: stack)` moves the boxes instead of replacing them. The result is stored in a local `let layout` before being called; `stack.layout(spacing:) { … }` does not compile because Swift reads the trailing closure as an argument to `layout(spacing:)`.

## FlowLayout algorithm

Items are placed left to right. When the next item would pass `maxWidth` and the row is not empty, the row ends and `y` moves down by the row's tallest item plus `spacing`. An item wider than `maxWidth` is placed alone on its row. The returned size is the widest row and the total height. A `nil` proposal width (an ideal-size query) is treated as unlimited, giving one row.

## ViewThatFits

`ViewThatFits(in: .horizontal)` tries an `HStack` of three bordered buttons and falls back to a `VStack`. The slider changes a fixed `.frame(width:)` around it to show the switch.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| `FlowLayout` measures subviews twice per pass | Extra work for large tag sets | Cache sizes with a `Cache` type if it is reused for many items |
| `FlowLayout` ignores right-to-left layout | Tags flow left to right in Arabic or Hebrew | Mirror `x` when `layoutDirection` is `.rightToLeft` |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUIFeatureTests` checks `FlowLayout.arrange` (row wrap, oversized item, empty input); `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: LAY-AC-01 to LAY-AC-03 on iPhone and iPad simulators.
