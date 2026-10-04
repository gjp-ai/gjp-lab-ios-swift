# Feature: Views & modifiers

Status: Implemented

## Goal

Show how SwiftUI views are composed and how modifiers wrap them, so a reader understands why modifier order matters and how to package reusable styling.

## Scope

### In scope

- Modifier order: the same `.padding` and `.background` in two orders, with a padding slider.
- A custom `ViewModifier` exposed as a `View` extension, toggled between two states.
- A small reusable view with a `@ViewBuilder` slot.
- Environment modifiers (`.font`) inherited by children and overridden by one child.

### Out of scope

- Custom containers built on `Layout` (see Layouts).
- Preference keys and `EnvironmentValues` definitions.

## Behavior

- Moving the padding slider updates both samples immediately.
- Turning **Highlight** on animates the callout to the emphasized style; turning it off restores it.

## UI & Navigation

- Entry point: **SwiftUI** category → **Views & modifiers** catalogue item (route `viewsModifiers`).
- A one-line introduction and four cards: **Modifier order**, **Custom modifier**, **Composition**, **Environment**.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Use only public SwiftUI APIs available on the app's deployment target (iOS 26.6).
- Sample data stays in memory; nothing is persisted, sent over the network, or logged.
- Colours come from `LabTheme` roles; main actions use `.buttonStyle(.labPrimary)`.
- The padding slider ranges 0–32 points in 1-point steps; the default is 12.

## Platform limitations

- None; all behavior is local to the view.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| VIEW-AC-01 | Move the padding slider | The padded background grows only in the *Padding first* sample; the *Background first* sample moves away from its border instead. |
| VIEW-AC-02 | Turn on Highlight | The callout switches to `primary` fill with `onPrimary` text. |
| VIEW-AC-03 | Open in dark mode | All samples stay readable on the Slate dark canvas. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/views/` (`ViewsModifiersScreen.swift`).
- `FeatureRoute.viewsModifiers` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "viewsModifiers"`.
- No new dependencies.

## Related documents

- [Slate design system](../../../common/theme/theme_detail_design.md) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
