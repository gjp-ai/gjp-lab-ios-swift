# Diagnosis workflow

## Establish evidence

- Capture the exact failure, scheme, configuration, destination and OS, command, first meaningful error, and reproduction steps.
- Reproduce with the smallest target. If you cannot, inspect logs and execution paths and label conclusions as hypotheses.
- Compare a known-good commit or configuration when useful; timing correlation is not proof.

## Classify the failure

| Symptom | Likely layer | First check |
| --- | --- | --- |
| `simctl` or `xcodebuild` produces no output for minutes | CoreSimulator service | `scripts/pick-simulator.sh`; if it exits 2, restart the service |
| Package resolution or "missing module" | SPM graph | `Package.resolved`, `xcodebuild -resolvePackageDependencies` |
| Actor-isolation or `Sendable` errors | Swift concurrency | Target isolation settings; then `swift-concurrency` |
| Deprecation or "only available in iOS N" warnings | API availability | Follow `ios-api-availability` |
| Crash on first use of camera, photos, location, etc. | Info.plist | Missing `NS…UsageDescription` in the generated Info.plist |
| Signing, provisioning, or entitlement errors | Code signing | Signed entitlements (`codesign -d --entitlements - <app>`) |
| Test passes locally, fails in CI or in parallel | Test harness | Follow `ios-testing` flaky-test workflow |
| Main-thread hang or jank | Runtime | Instruments (Time Profiler, Hangs) on a device |

Reduce variables one at a time. Inspect generated Info.plist, signed entitlements, derived sources, asset output, and the resolved package graph when they decide correctness. Explain why the proposed cause produces the evidence and what would disprove it.

## Fix and prevent regression

- Change the smallest responsible boundary without suppressing the symptom.
- Add a deterministic regression test at the lowest layer that proves the failure (see `ios-testing`).
- Re-run the reproduction and proportionate broader checks; report the confirmed cause and unverified scope.
