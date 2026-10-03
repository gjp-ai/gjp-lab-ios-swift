# Category sidebar detailed design

Status: Implemented

Requirements: [Category sidebar](sidebar_requirement.md)

## Implementation goal

Use one `NavigationSplitView` for every device: three columns on regular widths, collapsing automatically into a stack on compact widths, driven entirely by selection state.

## Source map

| Source | Responsibility |
| --- | --- |
| [`ContentView.swift`](../../../../GJPLab/app/ContentView.swift) | Owns the split view, `selectedCategory`, `selectedTopic`, and `detailPath`; renders feature destinations |
| [`CategorySidebar.swift`](../../../../GJPLab/app/navigation/CategorySidebar.swift) | Sidebar list and category rows |
| [`FeatureCatalogScreen.swift`](../../../../GJPLab/app/navigation/FeatureCatalogScreen.swift) | Content column: topic list with selection |
| [`FeatureRoute.swift`](../../../../GJPLab/app/navigation/FeatureRoute.swift) | `FeatureRoute` (topic selection) and `DetailRoute` (pushes inside the feature column) |
| [`navigation.json`](../../../../GJPLab/app/navigation/navigation.json) | Category order, text, icons, and topics |
| [`NavigationMenu.swift`](../../../../GJPLab/app/navigation/NavigationMenu.swift) | `NavigationMenu.main` decodes the JSON; `NavigationCategory.availableTopicCount` |

## Navigation model

```mermaid
flowchart LR
    Sidebar["Sidebar<br/>List(selection: selectedCategory)"] --> Content["Content<br/>List(selection: selectedTopic)"]
    Content --> Detail["Detail<br/>NavigationStack(path: detailPath)"]
    Detail --> Push["DetailRoute pushes<br/>(for example .response)"]
```

| State | Type | Owner | Reset when |
| --- | --- | --- | --- |
| `selectedCategory` | `NavigationCategory?` | `ContentView` | User goes back to the sidebar (compact) |
| `selectedTopic` | `FeatureRoute?` | `ContentView` | `selectedCategory` changes |
| `detailPath` | `[DetailRoute]` | `ContentView` | `selectedTopic` changes |

Selection, not pushed values, drives the first two levels. That is what lets the system collapse the columns on iPhone (selecting a row pushes the next column; back clears the selection) and keep them side by side on iPad. Screens inside a feature that need to push further (such as the URLSession response) append a `DetailRoute` to `detailPath`.

Only available topics are tagged in the catalogue list, so planned topics cannot become the selection.

## Rows

Each sidebar row is an icon, title, two-line description, and an availability label ("<n> available" or "Planned"), combined into one accessibility element with the hint "Opens the <category> catalogue". Text uses hierarchical styles (`.primary`, `.secondary`) so it stays readable on the system's selection highlight. The list keeps the system sidebar appearance (including Liquid Glass on iOS 26 and later) instead of the Slate canvas.

## Replaced design

This replaces the earlier card-grid dashboard (`MainScreen`) that pushed `.catalog(category)` onto a single `NavigationStack`. The grid used 2, 3, or 5 columns by width, left most of an iPad screen unused after the first tap, and truncated card text at large Dynamic Type sizes.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| No search across topics | Finding a topic means browsing categories | Add `.searchable` over all available topics |
| Selection is not restored after relaunch | The app always starts at the sidebar | Store the selected category and topic (both `Hashable`; make them `Codable`) |
| No deep links | Topics cannot be opened from a URL | Map URLs to `selectedCategory` and `selectedTopic` at one boundary |
| No UI test | Collapsing and back navigation are unguarded | Add an XCUITest that opens each available topic on iPhone and iPad |

## Verification

- Previews: `CategorySidebar` and `ContentView` (iPhone and iPad).
- Manual: SDB-AC-01 to SDB-AC-06 on an iPhone simulator and an iPad simulator in both orientations; VoiceOver and a large Dynamic Type size.
