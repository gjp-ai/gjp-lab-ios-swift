# Feature: Selection

Status: Implemented

## Goal

Show SwiftUI's selection controls by building a sample coffee order whose summary updates live.

## Scope

### In scope

- Single choice with a segmented and a menu `Picker`.
- `Toggle`, `Stepper`, and `Slider` for on/off and numeric values.
- Multi-selection of extras stored in a `Set`, using button-style toggles.
- `DatePicker` limited to future times and a `ColorPicker`.
- An order summary that combines every selection.

### Out of scope

- Placing or saving an order.
- Wheel and inline picker styles.

## Behavior

- Changing any control updates the **Your order** summary immediately.
- Espresso shots range 1–4; sweetness 0–100 %; the pickup date cannot be in the past.
- The summary lists extras in a fixed order using a locale-aware list format, or *No extras*.

## UI & Navigation

- Entry point: **SwiftUI** category → **Selection** catalogue item (route `selection`).
- A grouped `Form` with sections for single choice, values, multi-selection, dates and colours, and the order summary (read by VoiceOver as one element).
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- The shared [demo page rules](../../../common/theme/theme_detail_design.md#demo-pages) apply: public SwiftUI APIs on the deployment target only, sample data kept in memory (nothing persisted, sent, or logged), and `LabTheme` colours.
- The multi-selection binding is derived from the set (`binding(for:)`), not stored per extra.

## Platform limitations

- The colour picker's system sheet is outside the app's theme.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| SEL-AC-01 | Select Large and Iced | The summary reads *Large iced coffee…* and the icon changes to a takeaway cup. |
| SEL-AC-02 | Toggle Vanilla on and Cinnamon off | The summary lists only Vanilla. |
| SEL-AC-03 | Open the date picker | Past dates and times are disabled. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/selection/` (`SelectionScreen.swift`).
- `FeatureRoute.selection` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "selection"`.
- No new dependencies.

## Related documents

- [Detailed design](selection_detail_design.md)
- [Slate design system: demo pages](../../../common/theme/theme_detail_design.md#demo-pages) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
