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

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- Set and dictionary output is sorted before printing, so the output is the same on every run.

## UI & Navigation

- Entry point: **Swift** category → **Collections** catalogue item (route `collections`).
- Samples, in order: **Arrays**, **Sets**, **Dictionaries**, **map, filter, and reduce**, **Copies are independent**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.
- Output must be deterministic: never print a `Set` or `Dictionary` in its iteration order.

## Platform limitations

- None.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| COL-AC-01 | Run the *Sets* sample | Union, intersection, and subtraction are printed in sorted order, identical on every run. |
| COL-AC-02 | Run the *Copies are independent* sample | The original array is unchanged after the copy is modified. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/collections/`: `CollectionsScreen.swift` and `CollectionsSamples.swift`.
- `FeatureRoute.collections` maps to `CollectionsScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "collections"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](collections_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- Swift tutorial: [Closures and higher-order functions](../../../../guides/swift_tutorial.md#10-closures-and-higher-order-functions)
