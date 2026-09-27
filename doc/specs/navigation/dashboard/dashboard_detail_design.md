# Dashboard detailed design

Status: Implemented, with known gaps

Requirements: [Dashboard](dashboard_requirement.md)

## Implementation goal

Render every `DashboardCategory` as an adaptive grid of cards at the root of the navigation stack, and hand category selection to the navigation owner.

## Source map

| Source | Responsibility |
| --- | --- |
| [`MainScreen.swift`](../../../../GJPLab/navigation/dashboard/MainScreen.swift) | Header, adaptive grid, `CategoryCard`, and `DashboardLayout` |
| [`DashboardCategory.swift`](../../../../GJPLab/navigation/catalog/model/DashboardCategory.swift) | Category order, titles, dashboard descriptions, and SF Symbols |
| [`ContentView.swift`](../../../../GJPLab/app/ContentView.swift) | Owns the `NavigationStack` path; appends `.catalog(category)` on selection |
| [`LabTheme.swift`](../../../../GJPLab/common/theme/LabTheme.swift) | Canvas, card surface, and color roles |

## Ownership and navigation

`MainScreen` is stateless. It takes an `onCategorySelected` closure, so it never touches the navigation path; `ContentView` owns `[FeatureRoute]` and pushes `.catalog(category)`, which renders `FeatureCatalogScreen`.

## Layout

`GeometryReader` measures the available width, and `DashboardLayout` derives every metric from it:

| Width (points) | Columns | Card aspect ratio | Horizontal padding | Card content |
| --- | --- | --- | --- | --- |
| Under 600 | 2 | 1.1 | 20 | Compact (smaller icon and title) |
| 600–1099 | 3 | 1.45 | 32 | Regular |
| 1100 and above | 5 | 1.45 | 40 | Regular |

Each `CategoryCard` has a 6-point `LabTheme.primary` rail, an icon and title row (title one line, scaling down to 78%), and a two-line description, clipped to 24-point continuous corners with `labCard()`. Visual rules shared with the catalogue are owned by the [Slate design system](../../../architecture/design-system.md#adaptive-dashboard).

## Accessibility

Each card is a plain-style `Button`, so VoiceOver reads its contents as one element and adds the hint "Opens the <category> catalogue".

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Fixed card aspect ratio | At large Dynamic Type sizes the two-line description is likely to truncate | Let cards grow with content at accessibility sizes, or switch to a single column |
| Decorative icon is not hidden | VoiceOver may read the SF Symbol name before the title | Mark the icon `accessibilityHidden(true)` |
| No UI test | Category navigation is unguarded | Add an XCUITest that opens each catalogue by accessibility identifier |

## Verification

- Previews: "Phone", "Phone – dark", and "iPad" in `MainScreen.swift`.
- Manual: tap each category and go back; rotate an iPad and resize in Split View across 600 and 1100 points; check VoiceOver and a large Dynamic Type size.
