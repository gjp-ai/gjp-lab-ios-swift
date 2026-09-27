---
name: ios-testing
description: Design, write, run, or fix iOS tests with Swift Testing, XCTest, and XCUITest, including unit tests, async and concurrency tests, UI tests, test doubles and URLProtocol stubs, flaky tests, and test plans. Use when adding or updating tests for a change, a test fails or is flaky, deciding what to test and at which layer, or reading test results. Not for build, CI, or release configuration; use ios-build-release for those.
metadata:
  version: "0.3.0"
---

# iOS Testing

Prove the requested behavior with the cheapest deterministic test that would fail for the regression it guards against. Follow the host's test framework and conventions.

Pairs with the skill that owns the code under test, and `ios-build-release` for running tests in CI.

## Discover the host project

Read project instructions, test targets and frameworks (Swift Testing, XCTest, or both), test plans, existing fakes and fixtures, launch arguments used by UI tests, and how the app is put into a test state. Identify the behavior to prove, its failure modes, and what must be controlled (time, network, storage, remote config, permissions).

## Select a mode

- **Decide what to test, or write tests:** [test selection guide](references/test-selection.md).
- **A test is failing or flaky:** [flaky test workflow](references/flaky-tests.md).

## Gotchas

- `test` needs a concrete simulator destination; `generic/platform=iOS Simulator` only compiles. Get one with `ios-build-release/scripts/pick-simulator.sh`.
- Swift Testing runs tests in parallel and in random order. Shared static state, such as a global `URLProtocol` handler, causes flakes; isolate per test or mark the suite `.serialized`.
- Do not mix `XCTAssert` into `@Test` functions or `#expect` into XCTest methods.
- `@testable import` needs the test target's deployment target to be at least the app's.
- Run a subset with `-only-testing:Target/Suite/test` and read results with `-resultBundlePath R.xcresult` plus `xcrun xcresulttool get test-results summary --path R.xcresult`.
- Never fix a flaky test with fixed sleeps, `-retry-tests-on-failure`, or weaker assertions.

## Completion contract

- The new or changed test fails without the fix and passes with it (or you state why that was not checked).
- Tests control time, randomness, network, storage, and remote configuration; none depend on live services.
- Failure, empty, cancellation, and relevant accessibility paths are covered without duplicate assertions.
- Report the command, destination, pass/fail counts, skipped tests, and prerequisites such as device-only behavior.
