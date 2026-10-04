# Protocols & generics detailed design

Status: Implemented

Requirements: [Protocols & generics](generics_requirement.md)

## Implementation goal

Each sample is a static function in `ProtocolsGenericsSamples` whose body is the code shown on screen; `ProtocolsGenericsScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**.

## Source map

| Source | Responsibility |
| --- | --- |
| [`ProtocolsGenericsScreen.swift`](../../../../../GJPLab/features/swift/generics/ProtocolsGenericsScreen.swift) | Title, introduction, and previews |
| [`ProtocolsGenericsSamples.swift`](../../../../../GJPLab/features/swift/generics/ProtocolsGenericsSamples.swift) | Samples in display order (Protocols, Default implementations, Generic functions, Generic types, Associated types, some versus any) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.protocolsGenerics` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "protocolsGenerics"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.protocolsGenerics` to `ProtocolsGenericsScreen` |

## Ownership and state

- `ProtocolsGenericsSamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.protocolsGenerics`; pushes nothing.

## File-level declarations

Swift does not allow protocols inside functions, so `Shape2D`, `Describable`, `Container`, their conforming types, `Stack`, and the `some`/`any` factory functions are `fileprivate` at file level. `fileprivate` keeps names such as `Square` from clashing with SwiftUI or other features. Each snippet shows the declarations it uses above its code.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Snippet and function body are maintained by hand | They can drift apart | See the shared [code sample known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps) |
| `type(of:)` on local types is module-qualified | Not used here (all types are file-level) | Keep sample types at file level |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `someIsOneTypeAndAnyCanVary`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: GEN-AC-01 to the last acceptance criterion on an iPhone simulator in light and dark appearance, and at a large Dynamic Type size.
