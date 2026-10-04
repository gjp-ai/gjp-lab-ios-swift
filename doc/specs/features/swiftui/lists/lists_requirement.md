# Feature: Lists & grids

Status: Implemented

## Goal

Show data-driven collections: a sectioned `List` with editing and a lazy adaptive grid, sharing one search field.

## Scope

### In scope

- A `List` grouped into Fruit and Vegetables sections with row counts.
- Swipe actions (favourite, delete), `.onDelete` with **Edit** mode, and pull to refresh.
- A `LazyVGrid` with adaptive columns where tapping a tile toggles favourite.
- `.searchable` filtering both presentations, with an empty search state.
- A segmented control switching between List and Grid.

### Out of scope

- Persisting changes; leaving the screen restores the sample data.
- Reordering rows.

## Behavior

- Search matches names case- and diacritic-insensitively (`localizedStandardContains`).
- Pull to refresh waits one second and restores all 20 sample items, including deleted ones.
- **Edit** is shown only in List mode.
- When nothing matches, the system *No results* view is shown.

## UI & Navigation

- Entry point: **SwiftUI** category → **Lists & grids** catalogue item (route `listsGrids`).
- Picker inset above the content; inset-grouped list with `surface` rows on the canvas; grid tiles are bordered `surface` cards.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Use only public SwiftUI APIs available on the app's deployment target (iOS 26.6).
- Sample data stays in memory; nothing is persisted, sent over the network, or logged.
- Colours come from `LabTheme` roles; main actions use `.buttonStyle(.labPrimary)`.
- Rows use the item name as a stable identity.

## Platform limitations

- None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| LST-AC-01 | Swipe a row left and tap Delete | The row is removed and the section count drops. |
| LST-AC-02 | Pull down | After about one second all items are back. |
| LST-AC-03 | Search *an* | Only matching items are shown in both List and Grid. |
| LST-AC-04 | Search *zzz* | The empty search view is shown. |
| LST-AC-05 | Switch to Grid on iPad | More columns appear than on iPhone. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/lists/` (`ListsGridsScreen.swift`, `Produce.swift`).
- `FeatureRoute.listsGrids` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "listsGrids"`.
- No new dependencies.

## Related documents

- [Slate design system](../../../common/theme/theme_detail_design.md) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
