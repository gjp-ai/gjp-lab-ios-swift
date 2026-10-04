# Values & types detailed design

Status: Implemented, with known gaps

Requirements: [Values & types](basics_requirement.md)

## Implementation goal

Each sample is a static function in `BasicsSamples` whose body is the code shown on screen; `SwiftBasicsScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**. Snippet text and function body are kept in sync by hand; see the shared [known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps).

## Source map

| Source | Responsibility |
| --- | --- |
| [`SwiftBasicsScreen.swift`](../../../../../GJPLab/features/swift/basics/SwiftBasicsScreen.swift) | Title, introduction, and previews |
| [`BasicsSamples.swift`](../../../../../GJPLab/features/swift/basics/BasicsSamples.swift) | Samples in display order (Constants and variables, Type inference, Numbers and conversion, Overflow, Tuples) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.swiftBasics` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "swiftBasics"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.swiftBasics` to `SwiftBasicsScreen` |

## Ownership and state

- `BasicsSamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.swiftBasics`; pushes nothing.

## Code that does not compile

Lines that would be compile errors (changing a `let`, mixing `Int` and `Double`) and the trapping `largest + 1` are shown as comments with the error text, so the sample still runs.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| `type(of:)` prints module-qualified names for local types | Not an issue here (only standard types are printed), but surprising if a sample adds a local type | Print `String(describing: type(of:))` and strip the module prefix |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `basicsShowsInferredTypesAndWrappingOverflow`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: BAS-AC-01 to BAS-AC-02 on an iPhone simulator; the shared CS-AC-01 to CS-AC-07 are checked once for the category (see the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#acceptance-criteria)).
