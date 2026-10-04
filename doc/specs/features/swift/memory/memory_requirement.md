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

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- Each sample creates its objects inside a scope and prints the `deinit` messages that appear (or the absence of them) when the scope ends.
- Two samples leak on purpose to show the problem, and the leak is bounded: the strong retain cycle leaks one small object pair per run, and the strong closure capture leaks one object per run.

## UI & Navigation

- Entry point: **Swift** category → **Memory management** catalogue item (route `memory`).
- Samples, in order: **Object lifetime**, **Retain cycles and weak**, **Capturing self in closures**, **unowned**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.
- The `unowned` crash case is never executed.

## Platform limitations

- None.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| MEM-AC-01 | Run the retain-cycle sample | The strong version prints no `deinit`; the `weak` version prints both `deinit` messages. |
| MEM-AC-02 | Run the *Capturing self in closures* sample | Only the `[weak self]` downloader prints its `deinit`; the strong-capture one does not. |
| MEM-AC-03 | Run the `unowned` sample | The app does not crash; the output explains what would happen. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/memory/`: `MemoryScreen.swift` and `MemorySamples.swift`.
- `FeatureRoute.memory` maps to `MemoryScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "memory"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](memory_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
