# Feature: Runnable code sample

Status: Implemented

## Goal

Let a reader see a piece of Swift code next to the output it really produces, so each language feature is learned by running it rather than by reading a description. Every topic in the **Swift** category is a page of these samples.

## Scope

### In scope

- A topic page: a one-line introduction followed by one card per sample.
- Each card: a title, a one-line explanation, the code, a **Run** button, and the output of the last run.
- Running synchronous and asynchronous samples, and stopping a running sample when the reader leaves.

### Out of scope

- Editing code or running code the reader types (a playground).
- Syntax highlighting, sharing or exporting code, and keeping output after the topic closes.
- What each topic teaches; that is in the topic's own requirement in [`specs/features/swift/`](../../features/swift/).

## Behavior

- Opening a topic shows every sample with its code and an empty output area that reads "Tap Run to see the output".
- **Run** executes that sample's Swift code and shows the lines it logs below the code. Running again replaces the output instead of adding to it.
- The output comes from executing the code, never from hard-coded text, so it is the real result on this device.
- While a sample runs, its **Run** button shows progress and is disabled, so one sample never runs twice at the same time. Most samples finish instantly; none takes more than about a second.
- Leaving the topic stops any running sample. Output is not kept: reopening the topic shows empty output areas again.

## UI & Navigation

- Entry point: **Swift** category → any topic.
- A topic page uses the shared demo page: introduction, then cards, width-limited on iPad.
- The code uses a monospaced font, can be selected, and keeps its line breaks: long lines scroll sideways instead of wrapping.
- The output sits below a small "Output" label, uses a monospaced font, can be selected, and wraps.
- VoiceOver reads the explanation, the code, and the output as separate elements, and announces the output when a run finishes.
- Light and dark appearance and Dynamic Type are supported.

## Rules & Constraints

- The code shown is the code that runs. Samples log lines with `log(_:)` where a playground would call `print(_:)`.
- Sample code compiles in the app's Swift 5 language mode with default `MainActor` isolation and approachable concurrency, with no warnings.
- No sample crashes, hangs, blocks the main thread, calls the network, writes files, or logs user data. Code that would crash (force-unwrapping `nil`, `try!` on a failure, reading a released `unowned` reference) is shown in a comment and explained, never run.
- A sample's output is the same on every run: unordered collections are sorted and timing is described, not measured.
- Colours come from `LabTheme` roles; **Run** uses `.buttonStyle(.labPrimary)`.

## Platform limitations

- Asynchronous samples depend on the system's task scheduling; they are written so their output does not.

## Acceptance criteria

These apply to every Swift topic. Each topic's requirement adds criteria for its own samples.

| ID | Scenario | Expected result |
| --- | --- | --- |
| CS-AC-01 | Open any Swift topic | Every sample shows its code, an enabled **Run** button, and "Tap Run to see the output". |
| CS-AC-02 | Tap **Run** on a sample twice | Output appears after the first tap and is replaced, not appended, after the second. |
| CS-AC-03 | Run an asynchronous sample (Concurrency topic) | **Run** shows progress and is disabled until the sample finishes. |
| CS-AC-04 | Run a Concurrency sample and go back before it finishes, then reopen the topic | The sample stopped; no output is shown. |
| CS-AC-05 | Large Dynamic Type size, then dark appearance | Explanations and output wrap; code keeps its line breaks and scrolls sideways; everything stays readable. |
| CS-AC-06 | VoiceOver on a card, then **Run** | Explanation, code, and output are read separately; the output is announced when the run finishes. |
| CS-AC-07 | Unit tests | Every sample runs, logs at least one line, and logs the same lines on a second run. |

## Technical implementation constraints

- Shared source lives in `GJPLab/common/codesample/`; a topic supplies only its list of `CodeSample` values and a small screen.
- Running is tied to the card's lifetime, so leaving a topic cancels it without extra code in the topic.
- No new dependencies and no view models.

## Related documents

- [Detailed design](codesample_detail_design.md)
- [Slate design system](../theme/theme_detail_design.md#demo-pages) (the shared demo page)
- [Catalogue detailed design: Swift category](../../app/navigation/catalog_detail_design.md#swift-category)
- [Swift tutorial](../../../guides/swift_tutorial.md)
