# SwiftUI implementation workflow

## Establish the UI contract

Identify the primary action, supporting actions, displayed data, reachable states, and behavior that must remain unchanged. Do not combine a visual refactor with a navigation or state-management migration unless requested.

## Place state and effects

- Keep private control state in `@State`; use `@Binding` only when a parent owns the value; use an observable object only when its lifetime and sharing justify it.
- Keep user-entered or navigation-relevant transient state restorable when product requirements call for it. Do not treat `@State` as durable storage.
- Keep network, database, SDK, and platform work out of leaf views. Trigger it through explicit actions or the established presentation boundary.
- Avoid mutation while computing `body`. Tie asynchronous work to an appropriate `.task(id:)`, scene phase, or explicit user action, and make cancellation expected.

## Build a native hierarchy

- Use semantic colors that adapt to appearance; prefer `Color`, `ShapeStyle`, and asset-catalog roles over hard-coded light-only values.
- Prefer `NavigationStack`, `NavigationSplitView`, `List`, `Form`, `Button`, `Toggle`, `Picker`, `TextField`, `Alert`, `sheet`, and `ContentUnavailableView` before custom equivalents.
- Apply safe-area and keyboard handling once at the owning layout. Avoid stacked padding compensations.

| Intent | Prefer |
| --- | --- |
| Main action | Prominent `Button` with a concise verb |
| Secondary action | Borderless/plain button, toolbar action, or menu |
| Choice | `Picker`, `Toggle`, or a selection control with a label |
| Related content | `Section`, `GroupBox`, or a reusable card only when grouping clarifies intent |
| User input | Labelled `TextField`, `SecureField`, or a focused form control |
| Short status | Inline status text, alert, or an accessible confirmation appropriate to persistence |
| Focused task | Sheet, confirmation dialog, or full-screen cover when navigation semantics require it |

## Accessibility and verification

- Use system controls for VoiceOver behavior. Give icon-only controls explicit labels; hide decorative images from accessibility.
- Support Dynamic Type, text wrapping, logical focus order, adequate hit targets, and non-color status cues.
- Add previews for changed light/dark and meaningful states. Exercise keyboard, focus, system bars, permissions, navigation, and lifecycle behavior on a simulator/device when relevant.
- Run the smallest relevant build and test command and report checks that could not run.
