# Feature: Category catalogue

Status: Implemented

## Goal

Show every topic in a category, make clear which ones can be opened today, and open an implemented topic in one tap.

## Scope

### In scope

- The catalogue column for the selected category.
- A list of the category's topics with their availability.
- Selecting an available topic to show its feature.

### Out of scope

- The category sidebar (see the [sidebar requirement](../sidebar/sidebar_requirement.md)) and the feature screens.
- Search, filtering, or sorting topics.
- Hiding planned topics or showing release dates for them.

## Behavior

- The catalogue appears when a category is selected: beside the sidebar on iPad, pushed on iPhone.
- Topics appear in a fixed order defined per category.
- Selecting an available topic shows its feature: in the next column on iPad, pushed on iPhone.
- A planned topic is shown for orientation but cannot be selected.

## UI & Navigation

- Navigation title with the category name, and the category description above the topic list.
- One row per topic showing its title and description.
- Available rows end with a chevron and read as "Open"; planned rows end with a clock and read as "Planned".
- The selected topic is highlighted on iPad.
- Light and dark appearance and Dynamic Type are supported; descriptions wrap instead of truncating.

## Rules & Constraints

- Category names, descriptions, topics, and routes come from one source per category; the screen does not hard-code them.
- A topic is available only when it has a route; there is no separate "enabled" flag.
- Topic titles are unique within a category, and routes are unique across the catalogue.

## Platform limitations

None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| CAT-AC-01 | Select the HTTP Client category | URLSession shows a chevron; Alamofire shows a clock. |
| CAT-AC-02 | Select an available topic | Its feature is shown; on iPhone, back returns to the catalogue. |
| CAT-AC-03 | Tap a planned topic | Nothing happens. |
| CAT-AC-04 | VoiceOver on a row | It reads the title, description, and availability as one element. |
| CAT-AC-05 | Dark appearance and a large text size | Rows remain readable and descriptions wrap. |

## Technical implementation constraints

- Source lives in `GJPLab/navigation/catalog/`.
- The list binds to `ContentView`'s selected topic (`FeatureRoute?`); only available rows are tagged.
- A category may supply its topics from its feature folder (for example `SecurityCatalog`).

## Related documents

- [Detailed design](catalog_detail_design.md)
- [Sidebar requirement](../sidebar/sidebar_requirement.md)
- [Slate design system](../../../architecture/design-system.md)
