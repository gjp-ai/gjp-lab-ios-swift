# 0006: Topic pages share one layout; Swift samples are code shown and run

Status: Accepted, 2026-10-04

## Context

The Swift and SwiftUI categories added twenty topics at once. Each topic teaches several small techniques, so writing twenty bespoke screens and twenty full sets of docs would repeat the same layout, rules, and acceptance criteria many times. Swift language features have no visual output of their own, so their screens need another way to show what the code does.

## Decision

- Every Swift and SwiftUI topic is one page built from `LabDemoPage` and `LabDemoSection` (`common/theme/`): an introduction, then one card per technique.
- A Swift sample is a `CodeSample` (`common/codesample/`): the code as text, plus a static function whose body is that same code. **Run** calls the function and shows the lines it logs with `log(_:)`, so the output is real, not hard-coded.
- Behaviour and rules shared by all topics are written once, in `specs/common/codesample/codesample_requirement.md` and in the theme doc's *Demo pages* section. Each topic's requirement and detailed design hold only what is specific to that topic.

## Consequences

- A new topic is a sample list (Swift) or a page of cards (SwiftUI), a route, a JSON entry, and two short docs.
- Each sample's code is written twice, as text and as Swift. Nothing checks that they match yet; the [code sample design](../specs/common/codesample/codesample_detail_design.md#known-gaps) proposes a test.
- Types Swift cannot declare inside a function (protocols) live at file level as `fileprivate`, and the snippet shows them above the code that uses them.
- Changing the shared card or page changes every topic; review the shared requirement's acceptance criteria when doing so.
