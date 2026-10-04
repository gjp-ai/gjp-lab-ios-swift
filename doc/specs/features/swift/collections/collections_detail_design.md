# Collections detailed design

Status: Implemented

Requirements: [Collections](collections_requirement.md)

## Implementation goal

Each sample is a static function in `CollectionsSamples` whose body is the code shown on screen; `CollectionsScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**.

## Source map

| Source | Responsibility |
| --- | --- |
| [`CollectionsScreen.swift`](../../../../../GJPLab/features/swift/collections/CollectionsScreen.swift) | Title, introduction, and previews |
| [`CollectionsSamples.swift`](../../../../../GJPLab/features/swift/collections/CollectionsSamples.swift) | Samples in display order (Arrays, Sets, Dictionaries, map, filter, and reduce, Copies are independent) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.collections` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "collections"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.collections` to `CollectionsScreen` |

## Ownership and state

- `CollectionsSamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.collections`; pushes nothing.

## Deterministic output

`Set` and `Dictionary` have no fixed order, so every sample sorts them (`sorted()`, `sorted(by: { $0.key < $1.key })`) before logging. `everySampleLogsTheSameOutputEachRun` checks this.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Snippet and function body are maintained by hand | They can drift apart | See the shared [code sample known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps) |
| Copy-on-write is described, not shown | The sample cannot show when storage is actually copied | Show buffer identity with `withUnsafeBufferPointer` (advanced; out of scope for now) |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `collectionsSortUnorderedResults`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: COL-AC-01 to the last acceptance criterion on an iPhone simulator in light and dark appearance, and at a large Dynamic Type size.
