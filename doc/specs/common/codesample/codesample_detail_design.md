# Runnable code sample detailed design

Status: Implemented

Used by: every topic in the **Swift** category ([requirements](../../features/swift/)).

## Implementation goal

Show a piece of Swift code next to the output it really produces. A sample is a value that holds the code text and the function that is that code; a shared card shows it, runs it on request, and shows the output.

## Source map

| Source | Responsibility |
| --- | --- |
| [`CodeSample.swift`](../../../../GJPLab/common/codesample/CodeSample.swift) | `CodeSample` (title, explanation, code text, `run` function, `output()`) and `SampleLog` |
| [`CodeSampleCard.swift`](../../../../GJPLab/common/codesample/CodeSampleCard.swift) | `CodeSamplePage` (a `LabDemoPage` of cards) and `CodeSampleCard` (code, **Run**, output) |
| [`LabDemoSection.swift`](../../../../GJPLab/common/theme/LabDemoSection.swift) | The page and card layout the sample views build on |

## Ownership and state

- `CodeSample` is an immutable value. `run` is `@MainActor (SampleLog) async -> Void`: synchronous samples are wrapped in a closure (`run: { arrays($0) }`), asynchronous ones are awaited (`run: { await asyncLet($0) }`). The explicit closure keeps the call on the main actor; passing the method reference directly makes the compiler create a non-isolated thunk and warn.
- `SampleLog` collects lines through `callAsFunction`, so sample code reads `log("…")` like `print("…")`. It is `nonisolated` so `deinit` in the Memory samples, which does not run on the main actor, can log too. A new log is created for every run.
- `CodeSampleCard` owns `output` (`[String]?`, `nil` until the first run), `runCount`, and `isRunning` with `@State`. All of it is discarded when the topic closes.

## Run flow

1. **Run** increments `runCount`.
2. `.task(id: runCount)` starts: it sets `isRunning`, awaits `sample.output()`, stores the lines, clears `isRunning`, and posts a VoiceOver announcement with the output.
3. Because the work is a `.task` tied to the view, leaving the topic cancels it; the `Task.isCancelled` check stops a cancelled run from writing output. **Run** is disabled while a run is in progress, so runs never overlap, and each new run replaces the previous output.

## Layout

- Code: `.footnote.monospaced()`, selectable, `fixedSize(horizontal: true)` inside a horizontal `ScrollView` on `surfaceContainer`, so lines never wrap and scroll sideways at large text sizes.
- **Run**: `.buttonStyle(.labPrimary)`, with a spinner and "Running…" while running.
- Output: an "Output" caption, then the lines joined by newlines in `.footnote.monospaced()`, wrapping, inside a hairline `outlineVariant` border; "Tap Run to see the output" before the first run.
- UI-test identifiers: `codeSample.run` (each **Run** button) and `codeSample.output` (each output text once shown).

## Keeping code and output in sync

Each topic's `<Topic>Samples` enum stores the snippet as a raw string literal (`#"""…"""#`, so `\(…)` is shown, not interpolated) next to a static function whose body is the same code. Types that cannot be declared inside a function (protocols) or are shared by several samples live at file level as `fileprivate` declarations, and the snippet shows them above the code that uses them.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Snippet text and function body are written twice | They can drift apart unnoticed | Generate one from the other with a build-time script, or add a test that compares normalised text |
| No syntax highlighting | Code is harder to scan | Colour keywords with `AttributedString` using `LabTheme` roles |
| The VoiceOver announcement reads the whole output | Long outputs are tedious to hear | Announce "Output updated, N lines" and let users read the text |

## Verification

- Build with the project build command in [application architecture](../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample through `CodeSample.output()`; `SwiftTopicsUITests.testRunShowsTheSampleOutput` taps **Run** and reads `codeSample.output`.
- Manual: run a Concurrency sample and go back before it finishes; reopen the topic and confirm no output is shown.
