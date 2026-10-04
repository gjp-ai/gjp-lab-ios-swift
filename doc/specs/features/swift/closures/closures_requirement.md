# Feature: Functions & closures

Status: Implemented

## Goal

Show how Swift functions are declared and called, and how closures capture and carry behaviour.

## Scope

### In scope

- Argument labels, default parameter values, variadic parameters, and `inout`.
- Functions as values: passing a function to another function.
- Closure syntax from full form to shorthand `$0` and trailing closures.
- Capturing values: a counter factory whose closures keep their own state.
- `@escaping` explained with a stored completion handler.

### Out of scope

- Result builders and `async` closures (see Concurrency).
- Retain cycles from captures (see Memory management).

## Behavior

- Opening the topic shows every sample with its code visible and an empty output area ("Tap Run to see the output").
- Tapping **Run** executes that sample's Swift code and shows the lines it produces below the code. Running again replaces the output.
- Output comes from executing the code, never from hard-coded text. Output is discarded when the user leaves the topic.
- The counter sample calls two independent counters and shows each keeps its own count.

## UI & Navigation

- Entry point: **Swift** category → **Functions & closures** catalogue item (route `closures`).
- A one-line introduction, then one `LabDemoSection` card per sample containing: a one-line explanation; the code in a monospaced font, selectable, scrolling sideways instead of wrapping; a **Run** button (`.buttonStyle(.labPrimary)`); and an output area on `surfaceContainer`.
- VoiceOver reads the explanation, code, and output as separate elements, and announces the output when a run finishes.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Sample code compiles in the app's Swift 5 language mode with default `MainActor` isolation and approachable concurrency.
- The code shown is the code that runs: each sample is a plain function in the topic folder that returns its output lines, stored next to the snippet text it displays.
- No sample crashes, hangs, blocks the main thread, calls the network, writes files, or logs user data.
- Colours come from `LabTheme` roles; previews come in light and dark pairs.

## Platform limitations

- None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| FUN-AC-01 | Open the topic | Every sample shows its code, an enabled **Run** button, and an empty output area. |
| FUN-AC-02 | Tap **Run** twice on a sample | Output appears after the first tap and is replaced, not appended, after the second. |
| FUN-AC-03 | Run the closure-shorthand sample | Every form prints the same sorted result. |
| FUN-AC-04 | Run the counter sample | Two counters print independent sequences such as `1, 2, 3` and `1, 2`. |
| FUN-AC-05 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable on the dark canvas. |
| FUN-AC-06 | Unit tests | Every sample has a test that runs it and checks its output. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/closures/`.
- Add a `FeatureRoute.closures` case, map it in `ContentView.feature(for:)`, and add `"route": "closures"` to the topic in `app/navigation/navigation.json`.
- The topic belongs to the **Swift** category (id `swift`) in `navigation.json`, described in the [catalogue detailed design](../../../app/navigation/catalog_detail_design.md#swift-category).
- The page and sample cards come from the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) in `GJPLab/common/codesample/`; the topic supplies only its `CodeSample` list.
- No new dependencies and no view models.

## Related documents

- [Detailed design](closures_detail_design.md)
- [Runnable code sample](../../../common/codesample/codesample_detail_design.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
- [Application architecture](../../../../architecture/application.md)
