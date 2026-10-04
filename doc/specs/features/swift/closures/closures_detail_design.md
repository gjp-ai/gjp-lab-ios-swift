# Functions & closures detailed design

Status: Implemented, with known gaps

Requirements: [Functions & closures](closures_requirement.md)

## Implementation goal

Each sample is a static function in `ClosuresSamples` whose body is the code shown on screen; `ClosuresScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**. Snippet text and function body are kept in sync by hand; see the shared [known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps).

## Source map

| Source | Responsibility |
| --- | --- |
| [`ClosuresScreen.swift`](../../../../../GJPLab/features/swift/closures/ClosuresScreen.swift) | Title, introduction, and previews |
| [`ClosuresSamples.swift`](../../../../../GJPLab/features/swift/closures/ClosuresSamples.swift) | Samples in display order (Labels and default values, Variadic and inout parameters, Functions as values, Closure shorthand, Capturing values, Escaping closures) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.closures` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "closures"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.closures` to `ClosuresScreen` |

## Ownership and state

- `ClosuresSamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.closures`; pushes nothing.

## Nested functions

Each sample declares its helper functions inside the sample function, which keeps the snippet self-contained and shows that Swift allows local functions.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Escaping sample stores closures in a local array | It does not show the classic completion-handler-after-return case with real asynchrony | Acceptable; the Concurrency topic covers asynchronous work |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `closuresKeepTheirOwnCapturedState`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: FUN-AC-01 to FUN-AC-02 on an iPhone simulator; the shared CS-AC-01 to CS-AC-07 are checked once for the category (see the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#acceptance-criteria)).
