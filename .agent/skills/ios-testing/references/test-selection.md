# Test selection

Choose the cheapest test that exercises the behavior and fails for the intended regression.

| Behavior | Prefer |
| --- | --- |
| Pure mapping, policy, state transition, repository with fakes | Swift Testing (or the host's XCTest convention) unit test |
| Async contract, cancellation, actor behavior | Unit test with controllable fakes, clock, or `URLProtocol` |
| SwiftUI interaction, focus, navigation | XCUITest, or view-level testing the host already uses |
| Permission, entitlement, APNs, asset, lifecycle, system UI | Simulator or physical-device test |
| Cross-boundary critical contract | A small end-to-end path only when lower tests cannot prove it |

## Swift Testing

- `#expect` records and continues; `#require` stops the test (use it to unwrap preconditions).
- Parameterize with `@Test(arguments:)` instead of loops; group with `@Suite`; label with tags.
- Test callbacks and events with `confirmation`; bound slow tests with `.timeLimit`; mark known bugs with `withKnownIssue`.
- Suites run in parallel by default. Give each test its own fakes; use `.serialized` only for unavoidable shared resources.

## XCUITest

- Query elements by `accessibilityIdentifier`, not by visible text that localization or copy changes will break.
- Put the app into a deterministic state with launch arguments or environment (stub network, fixed date, reset storage).
- Wait with `waitForExistence(timeout:)` or expectations; never use fixed sleeps.

## Always

- Assert observable behavior, not view hierarchy or pixel positions unless visual fidelity is the contract.
- Control time, randomness, storage, network, and remote configuration.
- Cover the relevant failure, empty, cancellation, lifecycle, and accessibility paths without duplicate assertions.
- State simulator or device, locale, Dynamic Type, appearance, network, signing, or SDK prerequisites that affect results.
