# Accessibility & testing detailed design

Status: Implemented, with known gaps

Requirements: [Accessibility & testing](accessibility_requirement.md)

## Implementation goal

Each card demonstrates one accessibility tool, and the last card is the target of a UI test, so the topic shows both how assistive technologies read a screen and how XCUITest finds elements.

## Source map

| Source | Responsibility |
| --- | --- |
| [`AccessibilityScreen.swift`](../../../../../GJPLab/features/swiftui/accessibility/AccessibilityScreen.swift) | Screen, private `RatingControl`, `SettingRow`, and a `DynamicTypeSize.title` extension |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.accessibility` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "accessibility"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.accessibility` to the screen in `feature(for:)` |

## Ownership and state

- `AccessibilityScreen` owns `rating` (1–5, default 3) and `tapCount` with `@State`, and `iconSize` with `@ScaledMetric(relativeTo: .body)` (28 points at the default size).
- It reads `dynamicTypeSize`, `accessibilityReduceMotion`, `accessibilityDifferentiateWithoutColor`, `accessibilityReduceTransparency`, `accessibilityVoiceOverEnabled`, and `colorSchemeContrast` from the environment, so changes in Settings update the screen live.

## Adaptive layout for large text

When `dynamicTypeSize.isAccessibilitySize` is true, the Dynamic Type row uses `AnyLayout(VStackLayout)` instead of `HStackLayout`, so long text gets the full width.

## Rating control

Five plain buttons give touch users direct taps. `.accessibilityElement()` replaces them with one element for VoiceOver, labelled *Rating* with the value *N of 5 stars*, and `.accessibilityAdjustableAction` handles swipe up and down within 1–5.

## UI-test contract

The **Tap me** button has identifier `accessibility.tapButton` and the count text `accessibility.tapCount`. `SwiftUITopicsUITests.testAccessibilityTopicButtonCountsTaps` scrolls until the button is hittable, then checks the label changes from *Tapped 0 times* to *Tapped 1 time*. Identifiers are not read by VoiceOver and do not change with the language.

## Headings

`LabDemoSection` adds the `.isHeader` trait to every card title, so this and all other SwiftUI topics support the VoiceOver headings rotor.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| `DynamicTypeSize.title` strings are not localized | Labels stay in English | Move them to a String Catalog when the app is localized |
| UI test depends on the 3-second splash and the Remote Config timeout | Slow and network-sensitive start | Add a launch argument that skips the splash and Firebase fetch under UI tests |
| `colorSchemeContrast` is read only for Increase Contrast | Other contrast states are not shown | Acceptable; only `.increased` is meaningful today |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUITopicsUITests.testAccessibilityTopicButtonCountsTaps`; `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: A11Y-AC-01 to A11Y-AC-03 on a physical device with VoiceOver, or with the Accessibility Inspector on a simulator; A11Y-AC-01 also via the *large text* previews.
