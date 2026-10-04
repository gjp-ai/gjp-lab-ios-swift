# Feature: Navigation

Status: Implemented

## Goal

Show value-based pushes inside the app's single navigation stack, and the presentations (sheet, cover, popover, inspector) that sit on top of it.

## Scope

### In scope

- `NavigationLink(value:)` pushing `DetailRoute.navigationLevel` screens, any depth.
- Back one level with `dismiss` and pop to root by emptying `ContentView`'s path.
- A sheet with medium and large detents, a full-screen cover, and a popover kept as a popover on iPhone.
- A toolbar button and toggle that open an `.inspector`.
- An explanation of selection-driven split-view columns.

### Out of scope

- Deep links and URL schemes; the app registers none.
- State restoration of the path.

## Behavior

- Each pushed level shows its number and offers **Push level N+1**, **Back one level**, and **Pop to root**.
- **Pop to root** returns to the Navigation topic screen in one step.
- Presentations close themselves with `@Environment(\.dismiss)`; a full-screen cover always shows a **Close** button.

## UI & Navigation

- Entry point: **SwiftUI** category → **Navigation** catalogue item (route `navigationPatterns`).
- No extra `NavigationStack`: pushes use the detail column's stack owned by `ContentView`.
- The inspector is a side column on iPad and a sheet on iPhone.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Use only public SwiftUI APIs available on the app's deployment target (iOS 26.6).
- Sample data stays in memory; nothing is persisted, sent over the network, or logged.
- Colours come from `LabTheme` roles; main actions use `.buttonStyle(.labPrimary)`.
- `DetailRoute.navigationLevel(Int)` is handled in `ContentView`'s `navigationDestination`; the level screen receives `onPopToRoot` instead of the path.

## Platform limitations

- Inspector and popover presentation differ by size class; this is system behavior.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| NAV-AC-01 | Tap **Push level 1**, then **Push level 2** | Level 2 is shown; Back returns to level 1. |
| NAV-AC-02 | On level 3, tap **Pop to root** | The Navigation topic screen is shown. |
| NAV-AC-03 | Open the sheet | It stops at medium height and can be dragged to large. |
| NAV-AC-04 | Select another topic while on level 2 | The path is cleared and the new topic shows its root. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/navigation/` (`NavigationPatternsScreen.swift`, `NavigationLevelScreen.swift`).
- `FeatureRoute.navigationPatterns` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "navigationPatterns"`.
- No new dependencies.

## Related documents

- [Slate design system](../../../common/theme/theme_detail_design.md) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
