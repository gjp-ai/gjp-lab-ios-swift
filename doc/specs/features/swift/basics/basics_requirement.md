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

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- The *Overflow* sample shows `Int8.max &+ 1` wrapping to `-128`, and explains in a comment that plain `+` would stop the app instead of running it.

## UI & Navigation

- Entry point: **Swift** category → **Values & types** catalogue item (route `swiftBasics`).
- Samples, in order: **Constants and variables**, **Type inference**, **Numbers and conversion**, **Overflow**, **Tuples**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.
- Samples that would not compile are shown as code with an explanation and are not run.

## Platform limitations

- None.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| BAS-AC-01 | Run the *Type inference* sample | Each value is printed with its inferred type, for example `42: Int`, `3.5: Double`, and `42.0: Double` for the annotated value. |
| BAS-AC-02 | Run the *Overflow* sample | `Int8.max &+ 1 = -128` is printed and the app keeps running. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/basics/`: `SwiftBasicsScreen.swift` and `BasicsSamples.swift`.
- `FeatureRoute.swiftBasics` maps to `SwiftBasicsScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "swiftBasics"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](basics_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- Swift tutorial: [Constants, variables, and type inference](../../../../guides/swift_tutorial.md#1-constants-variables-and-type-inference), [Computed properties and property observers](../../../../guides/swift_tutorial.md#6-computed-properties-and-property-observers)
