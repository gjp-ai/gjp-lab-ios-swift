# Strings & regex detailed design

Status: Implemented

Requirements: [Strings & regex](strings_requirement.md)

## Implementation goal

Each sample is a static function in `StringsRegexSamples` whose body is the code shown on screen; `StringsRegexScreen` passes the list to the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) page, which runs a sample when the user taps **Run**.

## Source map

| Source | Responsibility |
| --- | --- |
| [`StringsRegexScreen.swift`](../../../../../GJPLab/features/swift/strings/StringsRegexScreen.swift) | Title, introduction, and previews |
| [`StringsRegexSamples.swift`](../../../../../GJPLab/features/swift/strings/StringsRegexSamples.swift) | Samples in display order (Characters and Unicode, String indices, Interpolation, multiline, and raw strings, Regex matching, Named captures, Comparing strings) |
| [`CodeSampleCard.swift`](../../../../../GJPLab/common/codesample/CodeSampleCard.swift) | Shared page, card, and run flow |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.stringsRegex` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | Swift catalogue entry (`"route": "stringsRegex"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.stringsRegex` to `StringsRegexScreen` |

## Ownership and state

- `StringsRegexSamples.all` is a static, immutable list. Each `CodeSample` stores the snippet text and a closure that calls the matching static function with a fresh `SampleLog`.
- The screen owns no state; each card owns its own output and running flag, discarded when the topic closes. Nothing is persisted, sent, or logged outside the sample output.
- Reached from `FeatureRoute.stringsRegex`; pushes nothing.

## Unicode test data

`"cafe\u{301}"` (decomposed é), a flag, and a family emoji make `count`, `unicodeScalars.count`, and `utf8.count` differ: 4/5/6, 1/2/8, and 1/5/18.

## Regex literals

Bare `/…/` literals compile in the app's Swift 5 mode because the project enables bare-slash regex (the Text & input validator already uses one).

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Snippet and function body are maintained by hand | They can drift apart | See the shared [code sample known gaps](../../../common/codesample/codesample_detail_design.md#known-gaps) |
| `localizedStandardContains` depends on the device locale | The comparison sample could differ in rare locales | Use `range(of:options:locale:)` with a fixed locale if that becomes a problem |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftTopicTests` runs every sample (non-empty, same output twice) and checks key lines in `stringsCountCharactersNotBytes`; `SwiftTopicsUITests.testEverySwiftTopicOpens` opens the screen from the catalogue.
- Manual: STR-AC-01 to the last acceptance criterion on an iPhone simulator in light and dark appearance, and at a large Dynamic Type size.
