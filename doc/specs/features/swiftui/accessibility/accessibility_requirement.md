# Feature: Accessibility & testing

Status: Implemented

## Goal

Show how SwiftUI describes meaning to assistive technologies and UI tests, and how a screen adapts to accessibility settings.

## Scope

### In scope

- Dynamic Type: the current size, a `@ScaledMetric` icon, and a row that becomes a column at accessibility sizes.
- Grouping with `.accessibilityElement(children: .combine)` and hiding decorative icons.
- A star rating as one adjustable element with label, value, and increment/decrement.
- A live readout of VoiceOver, Reduce Motion, Differentiate Without Colour, Reduce Transparency, and Increase Contrast.
- A button and count with `accessibilityIdentifier`s used by `SwiftUITopicsUITests`.

### Out of scope

- Localization and right-to-left layout.
- Voice Control–specific labels (`accessibilityInputLabels`).

## Behavior

- Changing a system accessibility setting updates the readout without reopening the screen.
- With VoiceOver, swiping up or down on the rating changes it between 1 and 5.
- Each tap on **Tap me** increments the count (*Tapped 1 time*, *Tapped 2 times*).

## UI & Navigation

- Entry point: **SwiftUI** category → **Accessibility & testing** catalogue item (route `accessibility`).
- Five cards: **Dynamic Type**, **Grouping and hiding**, **Custom control**, **Your settings**, **UI testing**.
- Every card title is a VoiceOver heading (from `LabDemoSection`).
- Setting state is shown as text (*On*/*Off*) as well as an icon.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- The shared [demo page rules](../../../common/theme/theme_detail_design.md#demo-pages) apply: public SwiftUI APIs on the deployment target only, sample data kept in memory (nothing persisted, sent, or logged), and `LabTheme` colours.
- Identifiers are `accessibility.tapButton` and `accessibility.tapCount`; do not rename them without updating the UI test.

## Platform limitations

- VoiceOver and most settings can only be fully checked on a device or with the Accessibility Inspector.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| A11Y-AC-01 | Set text size to an accessibility size | The Dynamic Type row stacks vertically and the icon grows. |
| A11Y-AC-02 | VoiceOver on the flight card | It is read as one element without the airplane icon. |
| A11Y-AC-03 | VoiceOver swipe up on the rating | The value increases by one star, up to 5. |
| A11Y-AC-04 | Run `SwiftUITopicsUITests` | The tap count changes from *Tapped 0 times* to *Tapped 1 time*. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/accessibility/` (`AccessibilityScreen.swift`).
- `FeatureRoute.accessibility` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "accessibility"`.
- No new dependencies.

## Related documents

- [Detailed design](accessibility_detail_design.md)
- [Slate design system: demo pages](../../../common/theme/theme_detail_design.md#demo-pages) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
