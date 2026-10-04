# Feature: Layouts

Status: Implemented

## Goal

Demonstrate SwiftUI's propose–choose–place layout model with stacks, grids, adaptive layouts, and a custom `Layout`.

## Scope

### In scope

- Switching between HStack, VStack, and ZStack with `AnyLayout`, plus a spacing slider.
- A `Grid` table with aligned columns.
- `ViewThatFits` switching between a row and a column as a box narrows.
- `FlowLayout`, a custom `Layout` that wraps tags onto new rows.

### Out of scope

- Lazy stacks and scrolling performance (see Lists & grids).
- `GeometryReader`-based layouts.

## Behavior

- Changing the stack type or spacing animates the three boxes to their new positions.
- Spacing is disabled for ZStack, which overlaps its children.
- Narrowing the ViewThatFits box below the width of the three buttons shows them in a column.

## UI & Navigation

- Entry point: **SwiftUI** category → **Layouts** catalogue item (route `layouts`).
- Four cards: **Stacks and AnyLayout**, **Grid alignment**, **ViewThatFits**, **Custom Layout**.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Use only public SwiftUI APIs available on the app's deployment target (iOS 26.6).
- Sample data stays in memory; nothing is persisted, sent over the network, or logged.
- Colours come from `LabTheme` roles; main actions use `.buttonStyle(.labPrimary)`.
- `FlowLayout.arrange(sizes:maxWidth:spacing:)` is a pure function so unit tests can check it without rendering.
- An item wider than the available width is placed on its own row rather than dropped.

## Platform limitations

- None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| LAY-AC-01 | Choose VStack | Boxes animate into a vertical column. |
| LAY-AC-02 | Choose ZStack | Boxes overlap, smallest on top; the spacing slider is disabled. |
| LAY-AC-03 | Narrow the ViewThatFits box | Buttons switch from a row to a column. |
| LAY-AC-04 | Unit tests | FlowLayout wraps full rows, places oversized items alone, and returns zero size for no items. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/layouts/` (`LayoutsScreen.swift`, `FlowLayout.swift`).
- `FeatureRoute.layouts` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "layouts"`.
- No new dependencies.

## Related documents

- [Slate design system](../../../common/theme/theme_detail_design.md) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
