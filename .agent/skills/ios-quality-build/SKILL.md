---
name: ios-quality-build
description: Diagnose, test, verify, and prepare iOS changes using Xcode builds, XCTest, Swift Testing, UI tests, Swift Package Manager, CI, performance checks, and release validation. Use for failures, regressions, dependency work, CI, or release readiness; not ordinary feature work unless verification is primary.
metadata:
  version: "0.1.0"
---

# iOS Quality and Build

Produce evidence that the requested iOS behavior works and that the affected build path remains healthy. Match verification depth to risk, and establish evidence before changing code for a diagnosis.

## Discover the host project

Read project instructions, Xcode project/workspace, schemes, build settings, package dependencies, test targets, CI configuration, and nearby test patterns. Identify the changed or failing behavior, smallest reproduction, affected destination and OS version, environment prerequisites, and release impact.

Preserve build and test conventions. Do not make broad Xcode, Swift, deployment-target, or dependency upgrades as incidental repair.

## Select a mode

- **Diagnose a failure or regression:** Read [the diagnosis workflow](references/diagnosis.md). Edit only when a fix is requested.
- **Design or add tests:** Read [the test selection guide](references/test-selection.md).
- **Xcode, dependency, CI, or release work:** Read [the build and release guide](references/xcode-release.md).

## Completion contract

- Reproduce or otherwise establish evidence before selecting a cause; distinguish root cause from secondary symptoms.
- Add the cheapest deterministic test that proves the requested behavior when practical.
- Run focused checks first, then broaden for affected targets, destinations, configurations, and release risk.
- Never mask failures by disabling checks, weakening assertions, arbitrary version pinning, or blanket retries.
- Report commands, outcomes, skipped checks, prerequisites, and residual risk.
