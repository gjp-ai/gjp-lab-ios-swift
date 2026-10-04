# Animation detailed design

Status: Implemented, with known gaps

Requirements: [Animation](animation_requirement.md)

## Implementation goal

Each card isolates one animation API. A single `motion(_:)` helper returns `nil` when Reduce Motion is on, so every sample honours the setting in one place.

## Source map

| Source | Responsibility |
| --- | --- |
| [`AnimationScreen.swift`](../../../../../GJPLab/features/swiftui/animation/AnimationScreen.swift) | Screen, `motion(_:)`, private `CurveKind`, `TransitionKind`, `Tab` |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.animation` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "animation"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.animation` to the screen in `feature(for:)` |

## Ownership and state

- `AnimationScreen` owns `isExpanded`, `curve`, `isAtEnd`, `transition`, `isCardVisible`, `selectedTab`, and `bounceCount` with `@State`, and a `@Namespace` for the matched underline.
- It reads `accessibilityReduceMotion` from the environment; changing the setting re-renders the screen.
- `PhaseAnimator` runs only while visible; no timers or tasks outlive the view.

## Implicit and explicit

The circle uses `.animation(motion(.bouncy), value: isExpanded)`: any change caused by `isExpanded` animates. The timing-curve dot uses `withAnimation(motion(curve.animation)) { isAtEnd.toggle() }`; the dot moves by changing its frame alignment between leading and trailing.

## Transitions

The card is inside `if isCardVisible`; insertion and removal use `transition.transition` (`AnyTransition`). The container has a fixed height and `.clipped()` so moving transitions do not draw over neighbouring cards.

## Matched geometry

Only the selected tab contains the underline `Capsule` with `.matchedGeometryEffect(id: "underline", in:)`. When selection changes inside `withAnimation`, SwiftUI animates the frame from the old tab to the new one. A clear placeholder keeps every tab the same height.

## Reduce Motion

`motion(_:)` returns `nil`, so changes apply instantly. The heart is a static image instead of a `PhaseAnimator`. The screen also shows a notice explaining why nothing moves.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Symbol `.bounce` is not suppressed by the screen | It follows system behavior when Reduce Motion is on | Skip incrementing the effect value when `reduceMotion` is true if a strict policy is needed |
| Curve durations are fixed at 0.8 seconds | No way to compare speeds | Add a duration slider |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: ANI-AC-01 to ANI-AC-04 on an iPhone simulator; ANI-AC-04 with Settings → Accessibility → Motion → Reduce Motion on.
