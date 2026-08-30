# Diagnosis workflow

## Establish evidence

- Capture the exact failure, scheme, configuration, destination/OS, command, first meaningful error, and reproducible steps.
- Reproduce with the smallest target. If unavailable, inspect logs and execution paths and label conclusions as hypotheses.
- Compare a known-good path or relevant change when useful; temporal correlation is not proof.

## Isolate the cause

- Separate compiler, Swift concurrency checking, asset catalog, Info.plist, entitlement, code-signing, package resolution, runtime, lifecycle, device, and test-harness failures.
- Reduce variables one at a time. Inspect generated Info.plist, signed entitlements, derived sources, asset output, and resolved package graph when they determine correctness.
- Explain why the proposed cause produces the evidence and what evidence would disprove it.

## Fix and prevent regression

- Change the smallest responsible boundary without suppressing the symptom.
- Add a deterministic regression test at the lowest layer that proves the failure; use UI/device tests only when framework integration is essential.
- Re-run the reproduction and proportionate broader checks, reporting confirmed cause and unverified scope.
