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

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- The value and reference samples run the same steps on a struct and a class, side by side, so the different results are easy to compare.

## UI & Navigation

- Entry point: **Swift** category → **Structs, classes & enums** catalogue item (route `typeSemantics`).
- Samples, in order: **Value and reference types**, **mutating methods**, **Enums with raw values**, **Associated values**, **Pattern matching**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.

## Platform limitations

- None.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| TYP-AC-01 | Run the *Value and reference types* sample | The struct original is unchanged; the class original shows the change. |
| TYP-AC-02 | Run the *Associated values* sample | Each payment prints the branch that matched with its associated value; only the 2,500 transfer matches the `where amount >= 1000` case. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/types/`: `TypeSemanticsScreen.swift` and `TypeSemanticsSamples.swift`.
- `FeatureRoute.typeSemantics` maps to `TypeSemanticsScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "typeSemantics"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](types_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- Swift tutorial: [Structs and classes](../../../../guides/swift_tutorial.md#3-structs-and-classes), [Enums](../../../../guides/swift_tutorial.md#4-enums), [switch and pattern matching](../../../../guides/swift_tutorial.md#5-switch-and-pattern-matching)
