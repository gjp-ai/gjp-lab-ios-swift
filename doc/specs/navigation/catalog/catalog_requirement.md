# Feature: Category catalogue

Status: Implemented

## Goal

Show every topic in a dashboard category, make clear which ones can be opened today, and open an implemented topic in one tap.

## Scope

### In scope

- One catalogue screen per dashboard category, opened from its dashboard card.
- A list of the category's topics with their availability.
- Navigation from an available topic to its feature screen.

### Out of scope

- The dashboard and the feature screens themselves.
- Search, filtering, or sorting topics.
- Hiding planned topics or showing release dates for them.

## Behavior

- The catalogue opens when the user taps a dashboard category; back returns to the dashboard.
- Topics appear in a fixed order defined per category.
- An available topic opens its feature screen when tapped.
- A planned topic is shown for orientation but cannot be opened.

## UI & Navigation

- Inline navigation title and a large heading with the category name, followed by a one-line category description.
- A table-style card with a primary top rail, a "Component / Status" header row, and one row per topic showing its title and description.
- Available rows end with a chevron and read as "Open"; planned rows end with a clock and read as "Planned".
- Content width is limited on iPad; light and dark appearance are supported.

## Rules & Constraints

- Category names, descriptions, topics, and routes come from one source per category; the screen does not hard-code them.
- A topic is available only when it has a route; there is no separate "enabled" flag.
- Topic titles are unique within a category.

## Platform limitations

None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| CAT-AC-01 | Open the HTTP Client category | URLSession shows a chevron; Alamofire shows a clock. |
| CAT-AC-02 | Tap an available topic | Its feature screen opens; back returns to the catalogue. |
| CAT-AC-03 | Tap a planned topic | Nothing happens. |
| CAT-AC-04 | VoiceOver on an available row | It reads the title and description as one element with the hint "Opens <title>". |
| CAT-AC-05 | Dark appearance and a large text size | Rows remain readable and descriptions wrap instead of truncating. |

## Technical implementation constraints

- Source lives in `GJPLab/navigation/catalog/`, with models in `model/`.
- Rows navigate with `NavigationLink(value:)` using `FeatureRoute`; destinations stay in `ContentView`.
- A category may supply its topics from its feature folder (for example `SecurityCatalog`).

## Related documents

- [Detailed design](catalog_detail_design.md)
- [Dashboard requirement](../dashboard/dashboard_requirement.md)
- [Slate design system](../../../architecture/design-system.md)
