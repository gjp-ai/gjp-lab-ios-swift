# Failing and flaky tests

## Reproduce

- Run only the failing test: `-only-testing:Target/Suite/test`.
- For intermittent failures: `-test-iterations 50 -run-tests-until-failure`. Add `-parallel-testing-enabled NO` to check whether parallelism is the trigger.
- Read the failure from the result bundle (`xcresulttool get test-results tests` and `test-details`), not from scrolled log output.

## Common causes

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Fails only in parallel or random order | Shared static state, singletons, `UserDefaults`, files | Per-test instances, injected storage, or `.serialized` |
| Fails on slow machines or CI | Fixed sleeps or real timers | Await observable state; inject a clock; use `confirmation` |
| UI test cannot find an element | Visible-text queries, animation, missing identifier | Query by `accessibilityIdentifier`; `waitForExistence(timeout:)` |
| Passes alone, fails after another test | Leaked state or unfinished tasks | Reset in setup; cancel tasks in teardown |
| Differs by locale, time zone, or date | Environment-dependent formatting | Fix locale, time zone, and date in the test |

## Fix

- Fix the cause in the test or the code, not by retrying.
- If the product code is wrong, fix it and keep the test as the regression guard.
- Re-run with iterations to confirm the flake is gone; report the iteration count.
