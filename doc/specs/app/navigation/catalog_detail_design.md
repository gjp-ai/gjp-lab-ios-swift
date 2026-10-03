# Category catalogue detailed design

Status: Implemented, with known gaps

Requirements: [Category catalogue](catalog_requirement.md)

## Implementation goal

Render a category's topics as a selectable list in the split view's content column, derive availability from whether a topic has a route, and let `ContentView` show the selected feature.

## Source map

| Source | Responsibility |
| --- | --- |
| [`FeatureCatalogScreen.swift`](../../../../GJPLab/app/navigation/FeatureCatalogScreen.swift) | Topic list bound to the selected topic, and `CatalogRow` |
| [`navigation.json`](../../../../GJPLab/app/navigation/navigation.json) | Every category and its topics, in display order; a topic with a `route` is available, one without is planned |
| [`NavigationMenu.swift`](../../../../GJPLab/app/navigation/NavigationMenu.swift) | Decodes the JSON into `NavigationCategory` and `NavigationTopic` (`id` is the title); `availableTopicCount` |
| [`FeatureRoute.swift`](../../../../GJPLab/app/navigation/FeatureRoute.swift) | Topic routes used as selection values; raw values are the JSON `route` strings |
| [`ContentView.swift`](../../../../GJPLab/app/ContentView.swift) | Owns `selectedTopic` and renders the feature for it |

## Ownership and selection

The screen receives a `NavigationCategory` and a `Binding<FeatureRoute?>`. It renders `List(selection:)`; an available row is tagged with its route, a planned row is not tagged, so it can never become the selection. The screen never builds a destination: `ContentView` maps the selected `FeatureRoute` to a feature view in the detail column. See the [sidebar detailed design](sidebar_detail_design.md#navigation-model) for how selection collapses into a stack on iPhone.

## Current topics

| Category | Available | Planned |
| --- | --- | --- |
| SwiftUI | — | 10 topics (views, layouts, text, buttons, selection, lists, navigation, animation, drawing, accessibility) |
| HTTP Client | URLSession | Alamofire |
| Security | Block App During Calls | Screenshot detection, screen capture detection, sensitive content |
| Integration | Firebase | — |
| Others | OS & hardware | — |

A unit test checks that routes are unique across the catalogue, because a duplicate route would make two rows share one selection.

## Accessibility

The category description is a plain, untagged first row, so it scrolls with the list and cannot be selected. Each topic is its own card (`.labListCard(isSelected:)`, the same card as the sidebar); the selected topic on iPad gets a 1-point `primary` border. Each row is combined into one accessibility element; the chevron is labeled "Open" and the clock "Planned". Descriptions use `fixedSize(horizontal: false, vertical: true)` so they wrap at large text sizes.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Category copy is out of date | Security's catalogue description mentions only screen capture; HTTP Client's sidebar text lists Moya and Siesta, and Others mentions Biometric ID, which have no topics | Update the `summary` and `description` in `navigation.json` to match the topics |
| `NavigationTopic.id` is the title | Two topics with the same title in one category would collide in `ForEach` | Keep titles unique (a rule) or use a stable key as the ID |
| No UI test | Topic selection is unguarded | Add an XCUITest that opens each available topic |

## Verification

- Previews: "HTTP client catalogue" (available and planned topics) and "SwiftUI catalogue" (planned only), each in light and dark, in `FeatureCatalogScreen.swift`.
- Unit tests: the bundled JSON decodes with unique category IDs; every `FeatureRoute` appears exactly once; an unknown route string fails to decode.
- Manual: select every category, select each available topic, and confirm planned rows cannot be selected, on iPhone and iPad.
