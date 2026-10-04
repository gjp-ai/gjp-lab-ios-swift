# Feature: Optionals

Status: Implemented

## Goal

Show how Swift represents a missing value and the safe ways to unwrap it.

## Scope

### In scope

- Declaring optionals and printing `nil` versus a value.
- `if let`, `guard let`, and the shorthand `if let name`.
- Nil-coalescing `??` and optional chaining through a nested value.
- `map` and `flatMap` on optionals.
- Why `!` crashes on `nil`, explained with a safe alternative.

### Out of scope

- Implicitly unwrapped optionals in Objective-C interop.

## Behavior

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- Each unwrapping sample runs twice, once with a value and once with `nil`, so both paths appear in the output.
- The force-unwrap sample never unwraps `nil`; it explains the crash and runs the `??` version.

## UI & Navigation

- Entry point: **Swift** category → **Optionals** catalogue item (route `optionals`).
- Samples, in order: **Optional values**, **if let**, **guard let**, **?? and optional chaining**, **map and flatMap**, **Force unwrapping**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.
- No sample uses `!` on a value that can be `nil` at run time.

## Platform limitations

- None.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| OPT-AC-01 | Run the *guard let* sample | Output shows the early-exit line for `nil` and the normal line for a value. |
| OPT-AC-02 | Run the *Force unwrapping* sample | The app does not crash; the output explains what `!` would do. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/optionals/`: `OptionalsScreen.swift` and `OptionalsSamples.swift`.
- `FeatureRoute.optionals` maps to `OptionalsScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "optionals"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](optionals_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- Swift tutorial: [Optionals](../../../../guides/swift_tutorial.md#2-optionals)
