# Feature: Collections

Status: Implemented

## Goal

Show Swift's three main collection types and the higher-order functions used to transform them.

## Scope

### In scope

- `Array`: append, insert, remove, index, and slicing with ranges.
- `Set`: uniqueness, membership, union, intersection, and subtraction.
- `Dictionary`: lookup returning an optional, default values, updating, and grouping with `Dictionary(grouping:by:)`.
- `map`, `filter`, `reduce`, `compactMap`, `flatMap`, `sorted(by:)`, and `first(where:)`.
- Copy-on-write: copying an array and changing the copy leaves the original unchanged.

### Out of scope

- Lazy sequences and custom `Sequence` conformances.
- `Collection` index internals.

## Behavior

- Opening the topic shows every sample with its code visible and an empty output area ("Tap Run to see the output").
- Tapping **Run** executes that sample's Swift code and shows the lines it produces below the code. Running again replaces the output.
- Output comes from executing the code, never from hard-coded text. Output is discarded when the user leaves the topic.
- Set and dictionary output is sorted before printing, so the output is the same on every run.

## UI & Navigation

- Entry point: **Swift** category → **Collections** catalogue item (route `collections`).
- A one-line introduction, then one `LabDemoSection` card per sample containing: a one-line explanation; the code in a monospaced font, selectable, scrolling sideways instead of wrapping; a **Run** button (`.buttonStyle(.labPrimary)`); and an output area on `surfaceContainer`.
- VoiceOver reads the explanation, code, and output as separate elements, and announces the output when a run finishes.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Sample code compiles in the app's Swift 5 language mode with default `MainActor` isolation and approachable concurrency.
- The code shown is the code that runs: each sample is a plain function in the topic folder that returns its output lines, stored next to the snippet text it displays.
- No sample crashes, hangs, blocks the main thread, calls the network, writes files, or logs user data.
- Colours come from `LabTheme` roles; previews come in light and dark pairs.
- Output must be deterministic: never print a `Set` or `Dictionary` in its iteration order.

## Platform limitations

- None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| COL-AC-01 | Open the topic | Every sample shows its code, an enabled **Run** button, and an empty output area. |
| COL-AC-02 | Tap **Run** twice on a sample | Output appears after the first tap and is replaced, not appended, after the second. |
| COL-AC-03 | Run the set-operations sample | Union, intersection, and subtraction are printed in sorted order, identical on every run. |
| COL-AC-04 | Run the copy-on-write sample | The original array is unchanged after the copy is modified. |
| COL-AC-05 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable on the dark canvas. |
| COL-AC-06 | Unit tests | Every sample has a test that runs it and checks its output. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/collections/`.
- Add a `FeatureRoute.collections` case, map it in `ContentView.feature(for:)`, and add `"route": "collections"` to the topic in `app/navigation/navigation.json`.
- The topic belongs to the **Swift** category (id `swift`) in `navigation.json`, described in the [catalogue detailed design](../../../app/navigation/catalog_detail_design.md#swift-category).
- The page and sample cards come from the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) in `GJPLab/common/codesample/`; the topic supplies only its `CodeSample` list.
- No new dependencies and no view models.

## Related documents

- [Detailed design](collections_detail_design.md)
- [Runnable code sample](../../../common/codesample/codesample_detail_design.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
- [Application architecture](../../../../architecture/application.md)
