# Lists & grids detailed design

Status: Implemented, with known gaps

Requirements: [Lists & grids](lists_requirement.md)

## Implementation goal

One `items` array feeds both a sectioned `List` and a `LazyVGrid`, filtered by a shared search query; a segmented picker in a top safe-area inset switches presentation.

## Source map

| Source | Responsibility |
| --- | --- |
| [`ListsGridsScreen.swift`](../../../../../GJPLab/features/swiftui/lists/ListsGridsScreen.swift) | Screen, list and grid builders, favourite and delete actions, private `Presentation`, `ProduceRow`, `ProduceTile` |
| [`Produce.swift`](../../../../../GJPLab/features/swiftui/lists/Produce.swift) | Sample model (`name` is the ID), `Kind`, and 20 `samples` |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.listsGrids` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "listsGrids"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.listsGrids` to the screen in `feature(for:)` |

## Ownership and state

- `ListsGridsScreen` owns `items` (`[Produce]`, starts as `Produce.samples`), `query`, and `presentation` with `@State`. Deletions and favourites last until the topic is closed.
- The screen uses its own `List`/`ScrollView` instead of `LabDemoPage`, because `List` must be the scrolling container for swipe actions and edit mode.
- `.refreshable` runs an async closure tied to the pull gesture; SwiftUI cancels it if the view goes away.

## Filtering and sections

`filteredItems` returns all items for an empty query, otherwise items whose name passes `localizedStandardContains`. The list loops over `Produce.Kind.allCases` and builds a `Section` only when that kind has rows.

## Editing

Rows have a leading favourite swipe action and a trailing destructive delete. `.onDelete` maps the section's offsets to items and deletes by ID, because offsets are relative to the filtered section, not to `items`. `EditButton` is in the toolbar only in List mode.

## Grid

`GridItem(.adaptive(minimum: 100))` fits as many 100-point columns as the width allows. Tiles are `.plain` buttons that toggle favourite, with the state given as the accessibility value.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| An empty `Section` exists only to show the footer hint | An extra gap at the end of the list | Move the hint into the last section's footer |
| Search and Edit stay available while the grid shows no edit actions | Minor inconsistency between modes | Hide search in grid mode, or accept it |
| Changes are lost on leaving the topic | Expected for a sample, but may surprise | Document only; persistence is out of scope |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUIFeatureTests.sampleProduceHasUniqueIDs`; `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: LST-AC-01 to LST-AC-05 on iPhone and iPad simulators.
