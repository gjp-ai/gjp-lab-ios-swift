# Error handling detailed design

Status: Implemented

Requirements: [Error handling](errors_requirement.md)

## Implementation goal

Each sample is a static function in `ErrorHandlingSamples` whose body is the code shown on screen; `ErrorHandlingScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**.

## Source map

| Source | Responsibility |
| --- | --- |
| [`ErrorHandlingScreen.swift`](../../../../../GJPLab/features/swift/errors/ErrorHandlingScreen.swift) | Title, introduction, and previews |
| [`ErrorHandlingSamples.swift`](../../../../../GJPLab/features/swift/errors/ErrorHandlingSamples.swift) | Samples in display order (throws, do, and catch, Typed throws, try? and try!, Result, defer) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.errorHandling` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "errorHandling"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.errorHandling` to `ErrorHandlingScreen` |

## Ownership and state

- `ErrorHandlingSamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.errorHandling`; pushes nothing.

## Shared validator

`ValidationError` and `validate(username:) throws(ValidationError)` are file-level and used by four samples; the *Typed throws* snippet shows their declarations.

## Typed `Result`

`Result { () throws(ValidationError) -> String in … }` spells out the closure type so `Result` infers `ValidationError` as its failure type instead of `any Error`.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Snippet and function body are maintained by hand | They can drift apart | See the shared [code sample known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps) |
| `try!` is only described | Readers do not see the crash | Intentional: the requirement forbids crashing samples |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `deferRunsOnSuccessAndFailure`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: ERR-AC-01 to the last acceptance criterion on an iPhone simulator in light and dark appearance, and at a large Dynamic Type size.
