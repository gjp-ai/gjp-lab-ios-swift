# Feature: Protocols & generics

Status: Implemented

## Goal

Show how protocols describe capabilities and how generics let one implementation work with many types.

## Scope

### In scope

- Declaring a protocol, conforming structs to it, and storing different conforming types in one `any` array.
- Protocol extensions with default implementations.
- Generic functions with constraints (`<T: Comparable>`) and a generic type (a small `Stack<Element>`).
- Associated types in a protocol.
- `some` (opaque) versus `any` (existential), with what each allows.

### Out of scope

- Primary associated types (`some Collection<Int>`).
- Parameter packs and variadic generics.

## Behavior

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- The *some versus any* sample shows that a `some` return value is always one concrete type, while an `any` return value can be a different type on each call.

## UI & Navigation

- Entry point: **Swift** category → **Protocols & generics** catalogue item (route `protocolsGenerics`).
- Samples, in order: **Protocols**, **Default implementations**, **Generic functions**, **Generic types**, **Associated types**, **some versus any**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.

## Platform limitations

- None.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| GEN-AC-01 | Run the *Default implementations* sample | A type that does not implement the method prints the default; one that does prints its own. |
| GEN-AC-02 | Run the *Generic types* sample | `Stack<Int>` and `Stack<String>` both push and pop correctly. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/generics/`: `ProtocolsGenericsScreen.swift` and `ProtocolsGenericsSamples.swift`.
- `FeatureRoute.protocolsGenerics` maps to `ProtocolsGenericsScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "protocolsGenerics"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](generics_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- Swift tutorial: [Protocols](../../../../guides/swift_tutorial.md#8-protocols), [Extensions](../../../../guides/swift_tutorial.md#9-extensions)
