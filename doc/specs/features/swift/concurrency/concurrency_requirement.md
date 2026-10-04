# Feature: Concurrency

Status: Implemented

## Goal

Show how Swift runs work concurrently and safely: async functions, parallel child tasks, cancellation, and actors.

## Scope

### In scope

- `async`/`await` calling a function that suspends.
- `async let` and `withTaskGroup` running work in parallel and collecting results.
- Cancellation: a long task that checks `Task.isCancelled` and stops early.
- An actor protecting a counter that many tasks update.
- `@MainActor` and `@concurrent`: which work runs on the main actor in this app and how to move work off it.

### Out of scope

- `AsyncSequence` and `AsyncStream`.
- Swift 6 language-mode migration (the app uses Swift 5 mode).

## Behavior

- Opening the topic shows every sample with its code visible and an empty output area ("Tap Run to see the output").
- Tapping **Run** executes that sample's Swift code and shows the lines it produces below the code. Running again replaces the output.
- Output comes from executing the code, never from hard-coded text. Output is discarded when the user leaves the topic.
- While a sample runs, it shows progress and its **Run** button is disabled until it finishes.
- Leaving the topic cancels running samples; their output is not shown later.
- Each sample takes at most two seconds.

## UI & Navigation

- Entry point: **Swift** category → **Concurrency** catalogue item (route `concurrency`).
- A one-line introduction, then one `LabDemoSection` card per sample containing: a one-line explanation; the code in a monospaced font, selectable, scrolling sideways instead of wrapping; a **Run** button (`.buttonStyle(.labPrimary)`); and an output area on `surfaceContainer`.
- VoiceOver reads the explanation, code, and output as separate elements, and announces the output when a run finishes.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Sample code compiles in the app's Swift 5 language mode with default `MainActor` isolation and approachable concurrency.
- The code shown is the code that runs: each sample is a plain function in the topic folder that returns its output lines, stored next to the snippet text it displays.
- No sample crashes, hangs, blocks the main thread, calls the network, writes files, or logs user data.
- Colours come from `LabTheme` roles; previews come in light and dark pairs.
- Running work is tied to the view's lifetime (for example with `.task(id:)`), not started from `onAppear` with an unstructured `Task`.
- Output never includes timings, thread names, or completion order that varies between runs; parallel results are sorted before printing.

## Platform limitations

- Scheduling differs between the simulator and a device, so samples must not rely on which task finishes first.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| CON-AC-01 | Open the topic | Every sample shows its code, an enabled **Run** button, and an empty output area. |
| CON-AC-02 | Tap **Run** twice on a sample | Output appears after the first tap and is replaced, not appended, after the second. |
| CON-AC-03 | Run the task-group sample | Results from every child task are printed in sorted order, identical on every run. |
| CON-AC-04 | Run the cancellation sample, then leave the topic | The sample stops; no output appears on the next visit. |
| CON-AC-05 | Run the actor sample | The final count equals the number of increments, every time. |
| CON-AC-06 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable on the dark canvas. |
| CON-AC-07 | Unit tests | Every sample has a test that runs it and checks its output. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/concurrency/`.
- Add a `FeatureRoute.concurrency` case, map it in `ContentView.feature(for:)`, and add `"route": "concurrency"` to the topic in `app/navigation/navigation.json`.
- The topic belongs to the **Swift** category (id `swift`) in `navigation.json`, described in the [catalogue detailed design](../../../app/navigation/catalog_detail_design.md#swift-category).
- The page and sample cards come from the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) in `GJPLab/common/codesample/`; the topic supplies only its `CodeSample` list.
- No new dependencies and no view models.

## Related documents

- [Detailed design](concurrency_detail_design.md)
- [Runnable code sample](../../../common/codesample/codesample_detail_design.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
- [Application architecture](../../../../architecture/application.md)
