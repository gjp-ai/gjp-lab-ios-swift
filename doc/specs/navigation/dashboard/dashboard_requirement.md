# Feature: Dashboard

Status: Implemented

## Goal

Give users one clear starting point that shows every lab category and opens its catalogue in one tap.

## Scope

### In scope

- The home screen shown after startup (unless maintenance is on).
- One card per dashboard category, and navigation to that category's catalogue.
- Adaptive layout for iPhone and iPad widths.

### Out of scope

- The catalogue screen and feature screens.
- Search, favorites, recently used items, or personalization.
- Showing feature availability on the dashboard (the catalogue shows it).

## Behavior

- The dashboard opens after startup when maintenance is disabled, and is the root of navigation.
- Tapping a category card opens that category's catalogue; back returns to the dashboard.
- Categories appear in this order: SwiftUI, HTTP Client, Security, Integration, Others.

## UI & Navigation

- Navigation title "GJP Lab", a large "iOS lab" heading, and a one-line introduction.
- Each card shows the category icon, title, and a short description on a surface card with a primary top rail.
- Column count follows the available width, not the device model: 2 columns under 600 points, 3 columns from 600 to 1099 points, and 5 columns at 1100 points and above.
- Each card is a single accessible button with a hint naming the catalogue it opens.
- Supports light and dark appearance.

## Rules & Constraints

- Category titles, descriptions, and icons come from one source (`DashboardCategory`); the dashboard does not hard-code them.
- Use `LabTheme` roles only; no raw colors.

## Platform limitations

None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| DSH-AC-01 | Startup completes with maintenance off | The dashboard shows all five categories in order. |
| DSH-AC-02 | Tap a category card | Its catalogue opens; back returns to the dashboard. |
| DSH-AC-03 | iPhone portrait (under 600 points wide) | Two columns. |
| DSH-AC-04 | iPad or a wide window (1100 points or more) | Five columns in one row. |
| DSH-AC-05 | Dark appearance | Cards, text, and rails use dark-mode colors and remain readable. |
| DSH-AC-06 | VoiceOver | Each card reads its title and description as one button with a hint. |

## Technical implementation constraints

- Source lives in `GJPLab/navigation/dashboard/`.
- `MainScreen` reports selection through `onCategorySelected`; `ContentView` owns the navigation path and appends `.catalog(category)`.
- Adding a category means adding a `DashboardCategory` case; the dashboard updates automatically.

## Related documents

- [Detailed design](dashboard_detail_design.md)
- [Slate design system](../../../architecture/design-system.md)
- [Application architecture](../../../architecture/application.md)
