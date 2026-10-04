# Buttons & actions detailed design

Status: Implemented, with known gaps

Requirements: [Buttons & actions](buttons_requirement.md)

## Implementation goal

Every action writes to one `lastAction` string shown at the top, so the screen proves each control fired without performing real side effects.

## Source map

| Source | Responsibility |
| --- | --- |
| [`ButtonsScreen.swift`](../../../../../GJPLab/features/swiftui/buttons/ButtonsScreen.swift) | Screen, `record(_:)`, `save()`, private `SortOrder` and `FlowRow` |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.buttonsActions` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "buttonsActions"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.buttonsActions` to the screen in `feature(for:)` |

## Ownership and state

- `ButtonsScreen` owns `lastAction`, `sortOrder`, `isConfirmingDelete`, `isShowingAlert`, `isSaving`, and `isFavorite` with `@State`.
- Presentations (`.confirmationDialog`, `.alert`) are driven by Bool state, so dismissing them sets the Bool back to `false`.
- `save()` starts an unstructured `Task` on the main actor (default isolation), sleeps 1.5 seconds, then clears `isSaving`.

## Styles

Only `.labPrimary`, `.bordered`, `.borderless`, and `.plain` are shown. `.borderedProminent` is excluded because the theme forbids it (white on white in dark mode). `FlowRow` uses `ViewThatFits` to fall back from one row to an adaptive grid at large text sizes.

## Gestures and accessibility

The gesture card has `.onTapGesture(count: 2)` and `.onLongPressGesture`, which VoiceOver cannot perform directly. Matching `.accessibilityAction(named:)` entries expose the same actions in the Actions rotor, and `.isButton` tells VoiceOver it is interactive.

## Touch targets

The favourite button's image gets `.frame(minWidth: 44, minHeight: 44)` and a rectangular `contentShape`, so the whole 44-point square is tappable, and an `accessibilityLabel` that names the action rather than the icon.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| The save `Task` is not cancelled when the screen disappears | `record("Saved")` can run after leaving the topic (harmless here) | Use `.task(id:)` driven by a trigger value, or keep the `Task` and cancel it in `onDisappear` |
| Context menu actions are not reachable without a long press on devices without VoiceOver | Some keyboard users cannot reach them | Also offer the actions in a visible `Menu` |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: BTN-AC-01 to BTN-AC-04 on an iPhone simulator; check BTN-AC-04 with VoiceOver on a device or with the Accessibility Inspector.
