# Concurrency detailed design

Status: Implemented, with known gaps

Requirements: [Concurrency](concurrency_requirement.md)

## Implementation goal

Each sample is a static function in `ConcurrencySamples` whose body is the code shown on screen; `ConcurrencyScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**. Snippet text and function body are kept in sync by hand; see the shared [known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps).

## Source map

| Source | Responsibility |
| --- | --- |
| [`ConcurrencyScreen.swift`](../../../../../GJPLab/features/swift/concurrency/ConcurrencyScreen.swift) | Title, introduction, and previews |
| [`ConcurrencySamples.swift`](../../../../../GJPLab/features/swift/concurrency/ConcurrencySamples.swift) | Samples in display order (async and await, async let, Task groups, Cancellation, Actors, Main actor and @concurrent) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.concurrency` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "concurrency"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.concurrency` to `ConcurrencyScreen` |

## Ownership and state

- `ConcurrencySamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.concurrency`; pushes nothing.

## Isolation

The app's default isolation is `MainActor`, so sample functions run on the main actor. Work called from child tasks lives in file-level `@concurrent` functions (`fetchGreeting`, `price`, `countSlowly`, `sumOfSquares`), and `isOnMainThread()` is `nonisolated`; `TicketCounter` is an actor. The *Main actor and @concurrent* sample proves the move by logging `Thread.isMainThread` before and inside the `@concurrent` function.

## Cancellation

Running samples are cancelled with the card's `.task` when the user leaves. The *Cancellation* sample uses a task group (structured), so cancelling the parent also cancels the counting child; an unstructured `Task {}` would keep running.

## Deterministic output

Results from parallel children are sorted; timing is described, never measured; the cancellation sample logs whether it stopped early, not how far it got. Each sample finishes in under a second.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| *async let* claims the waits overlapped without measuring it | The parallelism is asserted, not shown | Measure with `ContinuousClock` and log only `elapsed < 1 second`; keep it out of the determinism test |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `concurrencyResultsDoNotDependOnTiming`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: CON-AC-01 to CON-AC-04 on an iPhone simulator; the shared CS-AC-01 to CS-AC-07 are checked once for the category (see the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#acceptance-criteria)).
