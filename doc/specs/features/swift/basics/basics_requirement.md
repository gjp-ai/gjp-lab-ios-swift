# Feature: Values & types

Status: Implemented

## Goal

Show how Swift stores values: constants and variables, inferred and explicit types, and why Swift refuses to mix types without a conversion.

## Scope

### In scope

- `let` versus `var`, and what the compiler rejects when a constant is changed (explained, not compiled).
- Type inference and explicit annotations; `type(of:)` printing each inferred type.
- Numeric types: `Int`, `Double`, conversion between them, integer division, and overflow operators (`&+`).
- Tuples: building, naming elements, and destructuring.

### Out of scope

- Optionals (see Optionals) and collections (see Collections).
- Custom types (see Structs, classes & enums).

## Behavior

- Opening the topic shows every sample with its code visible and an empty output area ("Tap Run to see the output").
- Tapping **Run** executes that sample's Swift code and shows the lines it produces below the code. Running again replaces the output.
- Output comes from executing the code, never from hard-coded text. Output is discarded when the user leaves the topic.
- The overflow sample shows `Int.max &+ 1` wrapping, and explains that plain `+` would trap instead of running it.

## UI & Navigation

- Entry point: **Swift** category → **Values & types** catalogue item (route `swiftBasics`).
- A one-line introduction, then one `LabDemoSection` card per sample containing: a one-line explanation; the code in a monospaced font, selectable, scrolling sideways instead of wrapping; a **Run** button (`.buttonStyle(.labPrimary)`); and an output area on `surfaceContainer`.
- VoiceOver reads the explanation, code, and output as separate elements, and announces the output when a run finishes.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Sample code compiles in the app's Swift 5 language mode with default `MainActor` isolation and approachable concurrency.
- The code shown is the code that runs: each sample is a plain function in the topic folder that returns its output lines, stored next to the snippet text it displays.
- No sample crashes, hangs, blocks the main thread, calls the network, writes files, or logs user data.
- Colours come from `LabTheme` roles; previews come in light and dark pairs.
- Samples that would not compile are shown as code with an explanation and are not run.

## Platform limitations

- None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| BAS-AC-01 | Open the topic | Every sample shows its code, an enabled **Run** button, and an empty output area. |
| BAS-AC-02 | Tap **Run** twice on a sample | Output appears after the first tap and is replaced, not appended, after the second. |
| BAS-AC-03 | Run the type-inference sample | Each value is printed with its inferred type, for example `42: Int` and `3.14: Double`. |
| BAS-AC-04 | Run the overflow sample | The wrapped value is printed and the app keeps running. |
| BAS-AC-05 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable on the dark canvas. |
| BAS-AC-06 | Unit tests | Every sample has a test that runs it and checks its output. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/basics/`.
- Add a `FeatureRoute.swiftBasics` case, map it in `ContentView.feature(for:)`, and add `"route": "swiftBasics"` to the topic in `app/navigation/navigation.json`.
- The topic belongs to the **Swift** category (id `swift`) in `navigation.json`, described in the [catalogue detailed design](../../../app/navigation/catalog_detail_design.md#swift-category).
- The page and sample cards come from the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) in `GJPLab/common/codesample/`; the topic supplies only its `CodeSample` list.
- No new dependencies and no view models.

## Related documents

- [Detailed design](basics_detail_design.md)
- [Runnable code sample](../../../common/codesample/codesample_detail_design.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
- [Application architecture](../../../../architecture/application.md)
