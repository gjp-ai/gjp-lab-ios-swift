# Feature: Category sidebar

Status: Implemented

## Goal

Give users one starting point that lists every lab category, shows how much each one offers, and leads to its topics with the navigation pattern that suits the device.

## Scope

### In scope

- The first column of the app's three-column navigation: category list, availability, and selection.
- How the three columns (categories, catalogue, feature) behave on iPhone and iPad.

### Out of scope

- The catalogue column's contents (see the [catalogue requirement](../catalog/catalog_requirement.md)) and the feature screens.
- Search, favorites, recently used items, deep links, and restoring the last selection after relaunch.

## Behavior

- After startup (unless maintenance is on) the app shows the category sidebar.
- Selecting a category shows its catalogue; selecting an available topic shows the feature.
- **iPad and wide windows:** categories, catalogue, and feature appear side by side. Before a selection, the catalogue and feature columns show a short prompt.
- **iPhone and narrow windows:** the columns collapse into one stack: categories → catalogue → feature, with back navigation between them.
- Changing the category clears the selected topic; changing the topic returns the feature column to its first screen.
- Categories appear in this order: SwiftUI, HTTP Client, Security, Integration, Others.

## UI & Navigation

- Navigation title "GJP Lab".
- Each row shows the category icon, title, a short description, and its availability: "<n> available" when at least one topic can be opened, otherwise "Planned".
- The selected category is highlighted on iPad.
- Each row is one accessible element with a hint naming the catalogue it opens.
- Supports light and dark appearance and Dynamic Type; rows grow with text size.

## Rules & Constraints

- Category titles, descriptions, icons, and availability come from one source (`DashboardCategory`); the sidebar does not hard-code them.
- Availability is derived: a topic is available when it has a route.
- Use the system split-view behavior for collapsing and back navigation; do not switch between separate navigation implementations by device.

## Platform limitations

- Whether iPad shows two or three columns at once depends on the window width and orientation chosen by the system.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| SDB-AC-01 | Startup completes with maintenance off | The sidebar lists all five categories in order with their availability. |
| SDB-AC-02 | iPhone: tap a category, then an available topic | The catalogue, then the feature, are pushed; back returns step by step. |
| SDB-AC-03 | iPad landscape: select a category and a topic | Categories, catalogue, and feature are visible side by side. |
| SDB-AC-04 | iPad: select a different category while a feature is shown | The catalogue changes and the feature column returns to its prompt. |
| SDB-AC-05 | A category has no available topics | Its row reads "Planned". |
| SDB-AC-06 | VoiceOver | Each row reads its title, description, and availability as one element with a hint. |

## Technical implementation constraints

- Source lives in `GJPLab/navigation/sidebar/`.
- `ContentView` owns the `NavigationSplitView`, the selected category and topic, and the feature column's navigation path.
- Adding a category means adding a `DashboardCategory` case; the sidebar updates automatically.

## Related documents

- [Detailed design](sidebar_detail_design.md)
- [Catalogue requirement](../catalog/catalog_requirement.md)
- [Application architecture](../../../architecture/application.md)
