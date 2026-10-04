# Feature: Memory management

Status: Implemented

## Goal

Show how automatic reference counting (ARC) frees objects, how retain cycles stop that, and how `weak`, `unowned`, and capture lists fix it.

## Scope

### In scope

- Object lifetime: `deinit` printing when the last strong reference goes away.
- A retain cycle between two classes, and the same pair with a `weak` reference.
- A closure that captures `self` strongly, and the fixed version with `[weak self]`.
- `unowned`: when it fits, and why accessing it after release crashes (explained, not run).

### Out of scope

- Measuring real memory use; iOS does not report it per object.
- Unsafe pointers and manual memory management.

## Behavior

- Opening the topic shows every sample with its code visible and an empty output area ("Tap Run to see the output").
- Tapping **Run** executes that sample's Swift code and shows the lines it produces below the code. Running again replaces the output.
- Output comes from executing the code, never from hard-coded text. Output is discarded when the user leaves the topic.
- Each sample creates its objects inside a scope and prints the `deinit` messages that appear (or the absence of them) when the scope ends.
- Objects leaked by the retain-cycle sample are bounded: the sample creates one small pair per run.

## UI & Navigation

- Entry point: **Swift** category → **Memory management** catalogue item (route `memory`).
- A one-line introduction, then one `LabDemoSection` card per sample containing: a one-line explanation; the code in a monospaced font, selectable, scrolling sideways instead of wrapping; a **Run** button (`.buttonStyle(.labPrimary)`); and an output area on `surfaceContainer`.
- VoiceOver reads the explanation, code, and output as separate elements, and announces the output when a run finishes.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Sample code compiles in the app's Swift 5 language mode with default `MainActor` isolation and approachable concurrency.
- The code shown is the code that runs: each sample is a plain function in the topic folder that returns its output lines, stored next to the snippet text it displays.
- No sample crashes, hangs, blocks the main thread, calls the network, writes files, or logs user data.
- Colours come from `LabTheme` roles; previews come in light and dark pairs.
- The `unowned` crash case is never executed.

## Platform limitations

- None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| MEM-AC-01 | Open the topic | Every sample shows its code, an enabled **Run** button, and an empty output area. |
| MEM-AC-02 | Tap **Run** twice on a sample | Output appears after the first tap and is replaced, not appended, after the second. |
| MEM-AC-03 | Run the retain-cycle sample | The strong version prints no `deinit`; the `weak` version prints both `deinit` messages. |
| MEM-AC-04 | Run the `[weak self]` sample | The object is released after the closure is called. |
| MEM-AC-05 | Run the `unowned` sample | The app does not crash; the output explains what would happen. |
| MEM-AC-06 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable on the dark canvas. |
| MEM-AC-07 | Unit tests | Every sample has a test that runs it and checks its output. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/memory/`.
- Add a `FeatureRoute.memory` case, map it in `ContentView.feature(for:)`, and add `"route": "memory"` to the topic in `app/navigation/navigation.json`.
- The topic belongs to the **Swift** category (id `swift`) in `navigation.json`, described in the [catalogue detailed design](../../../app/navigation/catalog_detail_design.md#swift-category).
- The page and sample cards come from the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) in `GJPLab/common/codesample/`; the topic supplies only its `CodeSample` list.
- No new dependencies and no view models.

## Related documents

- [Detailed design](memory_detail_design.md)
- [Runnable code sample](../../../common/codesample/codesample_detail_design.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
- [Application architecture](../../../../architecture/application.md)
