# Feature: Animation

Status: Implemented

## Goal

Show how SwiftUI animates state changes, and how to respect the Reduce Motion setting.

## Scope

### In scope

- Implicit `.animation(_:value:)` on a growing circle.
- Explicit `withAnimation` with linear, ease, spring, and bouncy curves.
- Insertion and removal transitions chosen from a menu.
- `matchedGeometryEffect` moving a tab underline.
- `PhaseAnimator` and an SF Symbol `.bounce` effect.

### Out of scope

- Gesture-driven interactive animations and `KeyframeAnimator`.

## Behavior

- When Reduce Motion is on, a notice is shown, state changes apply without animation, the heart does not pulse, and symbol effects follow system behavior.

## UI & Navigation

- Entry point: **SwiftUI** category → **Animation** catalogue item (route `animation`).
- Five cards: **Implicit animation**, **Timing curves**, **Transitions**, **Matched geometry**, **Phase animation and symbol effects**.
- The selected tab is exposed to VoiceOver with the selected trait.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- The shared [demo page rules](../../../common/theme/theme_detail_design.md#demo-pages) apply: public SwiftUI APIs on the deployment target only, sample data kept in memory (nothing persisted, sent, or logged), and `LabTheme` colours.
- All animations are driven by local `@State`; none run timers outside the view's lifetime.

## Platform limitations

- Simulator frame rate may differ from a device.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| ANI-AC-01 | Tap **Grow** | The circle grows with a bounce and fills with `primary`. |
| ANI-AC-02 | Pick *Linear* then tap **Move** | The dot moves at constant speed. |
| ANI-AC-03 | Pick *Move from bottom* and tap **Remove** | The card slides down and fades out. |
| ANI-AC-04 | Turn on Reduce Motion | The notice appears and changes happen instantly. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/animation/` (`AnimationScreen.swift`).
- `FeatureRoute.animation` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "animation"`.
- No new dependencies.

## Related documents

- [Detailed design](animation_detail_design.md)
- [Slate design system: demo pages](../../../common/theme/theme_detail_design.md#demo-pages) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
