# Feature: Strings & regex

Status: Implemented

## Goal

Show how Swift strings handle Unicode correctly and how `Regex` finds and extracts text.

## Scope

### In scope

- `count` versus `utf8.count` and `unicodeScalars.count` for text with emoji and accents.
- String indices: why `string[2]` does not compile, and `index(_:offsetBy:)`, `prefix`, and `firstIndex(of:)`.
- Interpolation, multiline strings, and raw strings.
- `Regex` literals: matching, `firstMatch`, `matches(of:)`, and named captures.
- Comparing with `localizedStandardContains` and `==` on equivalent Unicode forms.

### Out of scope

- `AttributedString` and Markdown rendering (see SwiftUI → Text & input).
- Localization and String Catalogs.

## Behavior

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- Text with emoji and combining accents is used so that the different counts are visible.

## UI & Navigation

- Entry point: **Swift** category → **Strings & regex** catalogue item (route `stringsRegex`).
- Samples, in order: **Characters and Unicode**, **String indices**, **Interpolation, multiline, and raw strings**, **Regex matching**, **Named captures**, **Comparing strings**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.

## Platform limitations

- Locale-dependent comparisons use a fixed locale in tests so results do not change with the device language.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| STR-AC-01 | Run the *Characters and Unicode* sample | Character, scalar, and UTF-8 counts differ: 4/5/6 for the accented word, 1/2/8 for the flag, and 1/5/18 for the family emoji. |
| STR-AC-02 | Run the *Named captures* sample | Each capture is printed by name, for example `year: 2026`. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/strings/`: `StringsRegexScreen.swift` and `StringsRegexSamples.swift`.
- `FeatureRoute.stringsRegex` maps to `StringsRegexScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "stringsRegex"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](strings_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
