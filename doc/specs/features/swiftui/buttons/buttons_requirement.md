# Feature: Buttons & actions

Status: Implemented

## Goal

Show the ways people trigger actions in SwiftUI and how to make them clear, safe, and accessible.

## Scope

### In scope

- Button styles (`.labPrimary`, `.bordered`, `.borderless`, `.plain`) and control sizes.
- A destructive role with a confirmation dialog, and an alert.
- A `Menu` with a sort `Picker` and a context menu on a card.
- Double-tap and long-press gestures with matching named accessibility actions.
- An async save button that shows progress and is disabled while running.
- An icon-only favourite button with a 44-point target and an accessibility label.

### Out of scope

- Real deletion, sharing, or copying; every action only updates the **Last action** readout.
- `.borderedProminent` (disallowed by the theme).

## Behavior

- Every action writes a short description to **Last action** at the top of the screen.
- **Save** waits 1.5 seconds, during which it shows a spinner and cannot be pressed again.

## UI & Navigation

- Entry point: **SwiftUI** category → **Buttons & actions** catalogue item (route `buttonsActions`).
- A **Last action** card followed by five cards: styles, roles, menus, gestures, and async actions/touch targets.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Use only public SwiftUI APIs available on the app's deployment target (iOS 26.6).
- Sample data stays in memory; nothing is persisted, sent over the network, or logged.
- Colours come from `LabTheme` roles; main actions use `.buttonStyle(.labPrimary)`.
- Destructive actions always ask for confirmation first.

## Platform limitations

- Context menus and long-press need a touch screen or simulator pointer; VoiceOver users reach the same actions through the Actions rotor.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| BTN-AC-01 | Tap **Delete draft**, then **Delete** | A confirmation dialog appears; Last action reads *Deleted draft*. |
| BTN-AC-02 | Choose a sort order from the menu | Last action reads *Sorted by …*. |
| BTN-AC-03 | Tap **Save** | A spinner shows and the button is disabled for about 1.5 seconds, then Last action reads *Saved*. |
| BTN-AC-04 | VoiceOver on the heart button | It is read as *Add favourite* or *Remove favourite*. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/buttons/` (`ButtonsScreen.swift`).
- `FeatureRoute.buttonsActions` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "buttonsActions"`.
- No new dependencies.

## Related documents

- [Slate design system](../../../common/theme/theme_detail_design.md) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
