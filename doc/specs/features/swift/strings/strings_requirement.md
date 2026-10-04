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

- Opening the topic shows every sample with its code visible and an empty output area ("Tap Run to see the output").
- Tapping **Run** executes that sample's Swift code and shows the lines it produces below the code. Running again replaces the output.
- Output comes from executing the code, never from hard-coded text. Output is discarded when the user leaves the topic.
- Text with emoji and combining accents is used so that the different counts are visible.

## UI & Navigation

- Entry point: **Swift** category → **Strings & regex** catalogue item (route `stringsRegex`).
- A one-line introduction, then one `LabDemoSection` card per sample containing: a one-line explanation; the code in a monospaced font, selectable, scrolling sideways instead of wrapping; a **Run** button (`.buttonStyle(.labPrimary)`); and an output area on `surfaceContainer`.
- VoiceOver reads the explanation, code, and output as separate elements, and announces the output when a run finishes.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- Sample code compiles in the app's Swift 5 language mode with default `MainActor` isolation and approachable concurrency.
- The code shown is the code that runs: each sample is a plain function in the topic folder that returns its output lines, stored next to the snippet text it displays.
- No sample crashes, hangs, blocks the main thread, calls the network, writes files, or logs user data.
- Colours come from `LabTheme` roles; previews come in light and dark pairs.

## Platform limitations

- Locale-dependent comparisons use a fixed locale in tests so results do not change with the device language.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| STR-AC-01 | Open the topic | Every sample shows its code, an enabled **Run** button, and an empty output area. |
| STR-AC-02 | Tap **Run** twice on a sample | Output appears after the first tap and is replaced, not appended, after the second. |
| STR-AC-03 | Run the counting sample | Character, UTF-8, and scalar counts differ for the emoji text. |
| STR-AC-04 | Run the named-capture sample | Each capture is printed by name, for example `year: 2026`. |
| STR-AC-05 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable on the dark canvas. |
| STR-AC-06 | Unit tests | Every sample has a test that runs it and checks its output. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/strings/`.
- Add a `FeatureRoute.stringsRegex` case, map it in `ContentView.feature(for:)`, and add `"route": "stringsRegex"` to the topic in `app/navigation/navigation.json`.
- The topic belongs to the **Swift** category (id `swift`) in `navigation.json`, described in the [catalogue detailed design](../../../app/navigation/catalog_detail_design.md#swift-category).
- The page and sample cards come from the shared [runnable code sample](../../../common/codesample/codesample_detail_design.md) in `GJPLab/common/codesample/`; the topic supplies only its `CodeSample` list.
- No new dependencies and no view models.

## Related documents

- [Detailed design](strings_detail_design.md)
- [Runnable code sample](../../../common/codesample/codesample_detail_design.md)
- [Swift tutorial](../../../../guides/swift_tutorial.md)
- [Application architecture](../../../../architecture/application.md)
