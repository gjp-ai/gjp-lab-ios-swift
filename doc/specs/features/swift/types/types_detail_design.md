# Structs, classes & enums detailed design

Status: Implemented

Requirements: [Structs, classes & enums](types_requirement.md)

## Implementation goal

Each sample is a static function in `TypeSemanticsSamples` whose body is the code shown on screen; `TypeSemanticsScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**.

## Source map

| Source | Responsibility |
| --- | --- |
| [`TypeSemanticsScreen.swift`](../../../../../GJPLab/features/swift/types/TypeSemanticsScreen.swift) | Title, introduction, and previews |
| [`TypeSemanticsSamples.swift`](../../../../../GJPLab/features/swift/types/TypeSemanticsSamples.swift) | Samples in display order (Value and reference types, mutating methods, Enums with raw values, Associated values, Pattern matching) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.typeSemantics` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "typeSemantics"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.typeSemantics` to `TypeSemanticsScreen` |

## Ownership and state

- `TypeSemanticsSamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.typeSemantics`; pushes nothing.

## Side-by-side comparison

The value-and-reference sample performs the same three steps on a local struct and a local class, so the only difference in the output comes from the type kind.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Snippet and function body are maintained by hand | They can drift apart | See the shared [code sample known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps) |
| Inheritance is not shown | Readers do not see `override` or `super` | Add a small subclass sample if needed; most Swift code prefers protocols |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `structsCopyAndClassesShare`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: TYP-AC-01 to the last acceptance criterion on an iPhone simulator in light and dark appearance, and at a large Dynamic Type size.
