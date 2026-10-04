# Optionals detailed design

Status: Implemented

Requirements: [Optionals](optionals_requirement.md)

## Implementation goal

Each sample is a static function in `OptionalsSamples` whose body is the code shown on screen; `OptionalsScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**.

## Source map

| Source | Responsibility |
| --- | --- |
| [`OptionalsScreen.swift`](../../../../../GJPLab/features/swift/optionals/OptionalsScreen.swift) | Title, introduction, and previews |
| [`OptionalsSamples.swift`](../../../../../GJPLab/features/swift/optionals/OptionalsSamples.swift) | Samples in display order (Optional values, if let, guard let, ?? and optional chaining, map and flatMap, Force unwrapping) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.optionals` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "optionals"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.optionals` to `OptionalsScreen` |

## Ownership and state

- `OptionalsSamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.optionals`; pushes nothing.

## Both paths in one run

Each unwrapping sample calls its helper with a value and with `nil` (or invalid text), so the output always shows both branches.

## No real force unwrap

The force-unwrap sample keeps `stock["pear"]!` in a comment with the runtime message, and runs the `??` version.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Snippet and function body are maintained by hand | They can drift apart | See the shared [code sample known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps) |
| `String(describing:)` shows `Optional(42)` | Readers may think that is the display format to use | The sample text says it is for illustration; prefer `if let` in real UI |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `optionalsHandleBothValueAndNil`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: OPT-AC-01 to the last acceptance criterion on an iPhone simulator in light and dark appearance, and at a large Dynamic Type size.
