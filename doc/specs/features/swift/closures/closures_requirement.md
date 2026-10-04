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
- `@escaping`: closures stored and called after the registering function returns.

### Out of scope

- Result builders and `async` closures (see Concurrency).
- Retain cycles from captures (see Memory management).

## Behavior

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- The counter sample calls two independent counters and shows each keeps its own count.

## UI & Navigation

- Entry point: **Swift** category → **Functions & closures** catalogue item (route `closures`).
- Samples, in order: **Labels and default values**, **Variadic and inout parameters**, **Functions as values**, **Closure shorthand**, **Capturing values**, **Escaping closures**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.

## Platform limitations

- None.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| FUN-AC-01 | Run the *Closure shorthand* sample | Every form prints the same sorted result. |
| FUN-AC-02 | Run the *Capturing values* sample | Two counters print independent sequences such as `1, 2, 3` and `1, 2`. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/closures/`: `ClosuresScreen.swift` and `ClosuresSamples.swift`.
- `FeatureRoute.closures` maps to `ClosuresScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "closures"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](closures_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- Swift tutorial: [Closures and higher-order functions](../../../../guides/swift_tutorial.md#10-closures-and-higher-order-functions)
