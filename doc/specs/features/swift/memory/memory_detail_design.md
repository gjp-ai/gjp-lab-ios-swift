# Memory management detailed design

Status: Implemented

Requirements: [Memory management](memory_requirement.md)

## Implementation goal

Each sample is a static function in `MemorySamples` whose body is the code shown on screen; `MemoryScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**.

## Source map

| Source | Responsibility |
| --- | --- |
| [`MemoryScreen.swift`](../../../../../GJPLab/features/swift/memory/MemoryScreen.swift) | Title, introduction, and previews |
| [`MemorySamples.swift`](../../../../../GJPLab/features/swift/memory/MemorySamples.swift) | Samples in display order (Object lifetime, Retain cycles and weak, Capturing self in closures, unowned) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.memory` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "memory"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.memory` to `MemoryScreen` |

## Ownership and state

- `MemorySamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.memory`; pushes nothing.

## Logging from deinit

The classes are `nonisolated` because `deinit` does not run on the main actor, and each instance keeps the `SampleLog` of the run that created it. `SampleLog` is itself `nonisolated` for the same reason.

## Bounded leaks

The strong retain-cycle and strong-capture samples leak on purpose: one small `Owner`/`Pet` pair and one `Downloader` per run. Each keeps a reference to its run's `SampleLog`, so a leaked object never writes into a later run's output.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Snippet and function body are maintained by hand | They can drift apart | See the shared [code sample known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps) |
| Leaked objects accumulate while the app runs | A few hundred bytes per run of those two samples | Acceptable for a lab; break the cycle at the end of the sample if it ever matters |
| ARC may free an object right after its last use | In optimised builds `deinit` can appear earlier than the end of the scope | Tests only check that `deinit` appears before the next scope's line, which holds in both builds |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `retainCyclesKeepObjectsAliveAndWeakFreesThem`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: MEM-AC-01 to the last acceptance criterion on an iPhone simulator in light and dark appearance, and at a large Dynamic Type size.
