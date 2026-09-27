# Category catalogue detailed design

Status: Implemented, with known gaps

Requirements: [Category catalogue](catalog_requirement.md)

## Implementation goal

Render a category's topics as a table, derive availability from whether a topic has a route, and navigate by value through the app-owned navigation stack.

## Source map

| Source | Responsibility |
| --- | --- |
| [`FeatureCatalogScreen.swift`](../../../../GJPLab/navigation/catalog/FeatureCatalogScreen.swift) | Header, `CatalogTable`, and `CatalogRow` |
| [`CatalogItem.swift`](../../../../GJPLab/navigation/catalog/model/CatalogItem.swift) | Topic title, description, and optional `FeatureRoute`; `id` is the title |
| [`DashboardCategory.swift`](../../../../GJPLab/navigation/catalog/model/DashboardCategory.swift) | Per-category title, descriptions, icon, and `items` |
| [`SecurityCatalog.swift`](../../../../GJPLab/features/security/SecurityCatalog.swift) | Security topics, supplied from the feature folder |
| [`FeatureRoute.swift`](../../../../GJPLab/navigation/FeatureRoute.swift) | Route values used by available rows |
| [`ContentView.swift`](../../../../GJPLab/app/ContentView.swift) | Pushes `.catalog(category)` and renders every destination |

## Ownership and navigation

The screen is stateless and receives a `DashboardCategory`. An available row is a `NavigationLink(value: route)`, so the row never builds its destination; `ContentView`'s `navigationDestination(for: FeatureRoute.self)` does. A planned row (`route == nil`) is plain content.

## Current topics

| Category | Available | Planned |
| --- | --- | --- |
| SwiftUI | — | 10 topics (views, layouts, text, buttons, selection, lists, navigation, animation, drawing, accessibility) |
| HTTP Client | URLSession | Alamofire |
| Security | Block App During Calls | Screenshot detection, screen capture detection, sensitive content |
| Integration | Firebase | — |
| Others | OS & hardware | — |

## Accessibility

Available rows get the hint "Opens <title>", and the chevron is labeled "Open"; planned rows label the clock "Planned". Descriptions use `fixedSize(horizontal: false, vertical: true)` so they wrap at large text sizes.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Planned rows are not combined for VoiceOver | Title, description, and "Planned" are read as separate elements | Apply `.accessibilityElement(children: .combine)` to planned rows |
| Category copy is out of date | Security's catalogue description mentions only screen capture; HTTP Client's dashboard text lists Moya and Siesta, and Others mentions Biometric ID, which have no topics | Update `DashboardCategory` descriptions to match `items` |
| `CatalogItem.id` is the title | Two topics with the same title in one category would collide in `ForEach` | Keep titles unique (now a rule) or use the route or a stable key as the ID |
| No UI test | Catalogue navigation is unguarded | Add an XCUITest that opens each available topic |

## Verification

- Previews: "HTTP client catalogue" and "SwiftUI catalogue – dark" in `FeatureCatalogScreen.swift`.
- Manual: open every category, tap each available topic and go back, and confirm planned rows do nothing; check VoiceOver and a large Dynamic Type size.
