# Feature: Error handling

Status: Implemented

## Goal

Show how Swift functions report failure and how callers handle, convert, or pass on errors.

## Scope

### In scope

- Defining errors as an enum that conforms to `Error`.
- `throws`, `try`, and `do`/`catch` with pattern-matched catch clauses.
- Typed throws (`throws(ValidationError)`).
- `try?` turning an error into `nil`, and why `try!` is avoided.
- `Result` and `get()`.
- `defer` running cleanup on both success and failure.

### Out of scope

- `async` throwing functions (see Concurrency).
- `NSError` bridging.

## Behavior

- Opening the topic shows every sample with its code visible and an empty output area ("Tap Run to see the output").
- Tapping **Run** executes that sample's Swift code and shows the lines it produces below the code. Running again replaces the output.
- Output comes from executing the code, never from hard-coded text. Output is discarded when the user leaves the topic.
- Each throwing sample runs with an input that succeeds and one that fails, so both paths appear in the output.
- The `try!` sample never runs `try!` on a failing call; it explains the crash and runs the `try?` version.

## UI & Navigation

- Entry point: **Swift** category → **Error handling** catalogue item (route `errorHandling`).
- A one-line introduction, then one `LabDemoSection` card per sample containing: a one-line explanation; the code in a monospaced font, selectable, scrolling sideways instead of wrapping; a **Run** button (`.buttonStyle(.labPrimary)`); and an output area on `surfaceContainer`.
- VoiceOver reads the explanation, code, and output as separate elements, and announces the output when a run finishes.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Sample code compiles in the app's Swift 5 language mode with default `MainActor` isolation and approachable concurrency.
- The code shown is the code that runs: each sample is a plain function in the topic folder that returns its output lines, stored next to the snippet text it displays.
- No sample crashes, hangs, blocks the main thread, calls the network, writes files, or logs user data.
- Colours come from `LabTheme` roles; previews come in light and dark pairs.
- No sample uses `try!` on a call that can throw at run time.

## Platform limitations

- None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| ERR-AC-01 | Open the topic | Every sample shows its code, an enabled **Run** button, and an empty output area. |
| ERR-AC-02 | Tap **Run** twice on a sample | Output appears after the first tap and is replaced, not appended, after the second. |
| ERR-AC-03 | Run the `defer` sample | The cleanup line is printed for both the success and the failure run. |
| ERR-AC-04 | Run the typed-throws sample | The catch clause receives the concrete error type and prints its case. |
| ERR-AC-05 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable on the dark canvas. |
| ERR-AC-06 | Unit tests | Every sample has a test that runs it and checks its output. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/errors/`.
- Add a `FeatureRoute.errorHandling` case, map it in `ContentView.feature(for:)`, and add `"route": "errorHandling"` to the topic in `app/navigation/navigation.json`.
- The topic belongs to the **Swift** category (id `swift`) in `navigation.json`, described in the [catalogue detailed design](../../../app/navigation/catalog_detail_design.md#swift-category).
- The page and sample cards come from the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) in `GJPLab/common/codesample/`; the topic supplies only its `CodeSample` list.
- No new dependencies and no view models.

## Related documents

- [Detailed design](errors_detail_design.md)
- [Runnable code sample](../../../common/codesample/codesample_detail_design.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
- [Application architecture](../../../../architecture/application.md)
