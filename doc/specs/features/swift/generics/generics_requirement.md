# Feature: Protocols & generics

Status: Implemented

## Goal

Show how protocols describe capabilities and how generics let one implementation work with many types.

## Scope

### In scope

- Declaring a protocol and conforming structs and classes to it.
- Protocol extensions with default implementations.
- Generic functions with constraints (`<T: Comparable>`) and a generic type (a small `Stack<Element>`).
- Associated types in a protocol.
- `some` (opaque) versus `any` (existential), with what each allows.

### Out of scope

- Primary associated types beyond one example.
- Parameter packs and variadic generics.

## Behavior

- Opening the topic shows every sample with its code visible and an empty output area ("Tap Run to see the output").
- Tapping **Run** executes that sample's Swift code and shows the lines it produces below the code. Running again replaces the output.
- Output comes from executing the code, never from hard-coded text. Output is discarded when the user leaves the topic.
- The `some` versus `any` sample shows that an `any` array can mix conforming types, while a `some` return value always has one concrete type.

## UI & Navigation

- Entry point: **Swift** category → **Protocols & generics** catalogue item (route `protocolsGenerics`).
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
| GEN-AC-01 | Open the topic | Every sample shows its code, an enabled **Run** button, and an empty output area. |
| GEN-AC-02 | Tap **Run** twice on a sample | Output appears after the first tap and is replaced, not appended, after the second. |
| GEN-AC-03 | Run the default-implementation sample | A type that does not implement the method prints the default; one that does prints its own. |
| GEN-AC-04 | Run the generic stack sample | `Stack<Int>` and `Stack<String>` both push and pop correctly. |
| GEN-AC-05 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable on the dark canvas. |
| GEN-AC-06 | Unit tests | Every sample has a test that runs it and checks its output. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/generics/`.
- Add a `FeatureRoute.protocolsGenerics` case, map it in `ContentView.feature(for:)`, and add `"route": "protocolsGenerics"` to the topic in `app/navigation/navigation.json`.
- The topic belongs to the **Swift** category (id `swift`) in `navigation.json`, described in the [catalogue detailed design](../../../app/navigation/catalog_detail_design.md#swift-category).
- The page and sample cards come from the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) in `GJPLab/common/codesample/`; the topic supplies only its `CodeSample` list.
- No new dependencies and no view models.

## Related documents

- [Detailed design](generics_detail_design.md)
- [Runnable code sample](../../../common/codesample/codesample_detail_design.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
- [Application architecture](../../../../architecture/application.md)
