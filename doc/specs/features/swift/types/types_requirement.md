# Feature: Structs, classes & enums

Status: Implemented

## Goal

Show the difference between value and reference types, and how enums with associated values model choices.

## Scope

### In scope

- Value semantics: copying a struct and changing the copy.
- Reference semantics: two variables pointing at one class instance, and identity with `===`.
- `mutating` methods on structs and `let` versus `var` instances.
- Enums with raw values and with associated values.
- `switch` with pattern matching, `where` clauses, and exhaustiveness.

### Out of scope

- Protocols and generics (see Protocols & generics).
- Inheritance hierarchies beyond one subclass.

## Behavior

- Opening the topic shows every sample with its code visible and an empty output area ("Tap Run to see the output").
- Tapping **Run** executes that sample's Swift code and shows the lines it produces below the code. Running again replaces the output.
- Output comes from executing the code, never from hard-coded text. Output is discarded when the user leaves the topic.
- The value and reference samples run the same steps on a struct and a class, side by side, so the different results are easy to compare.

## UI & Navigation

- Entry point: **Swift** category → **Structs, classes & enums** catalogue item (route `typeSemantics`).
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
| TYP-AC-01 | Open the topic | Every sample shows its code, an enabled **Run** button, and an empty output area. |
| TYP-AC-02 | Tap **Run** twice on a sample | Output appears after the first tap and is replaced, not appended, after the second. |
| TYP-AC-03 | Run the value-versus-reference sample | The struct original is unchanged; the class original shows the change. |
| TYP-AC-04 | Run the pattern-matching sample | Each enum case prints the branch that matched, including its associated value. |
| TYP-AC-05 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable on the dark canvas. |
| TYP-AC-06 | Unit tests | Every sample has a test that runs it and checks its output. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/types/`.
- Add a `FeatureRoute.typeSemantics` case, map it in `ContentView.feature(for:)`, and add `"route": "typeSemantics"` to the topic in `app/navigation/navigation.json`.
- The topic belongs to the **Swift** category (id `swift`) in `navigation.json`, described in the [catalogue detailed design](../../../app/navigation/catalog_detail_design.md#swift-category).
- The page and sample cards come from the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) in `GJPLab/common/codesample/`; the topic supplies only its `CodeSample` list.
- No new dependencies and no view models.

## Related documents

- [Detailed design](types_detail_design.md)
- [Runnable code sample](../../../common/codesample/codesample_detail_design.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
- [Application architecture](../../../../architecture/application.md)
