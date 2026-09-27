---
name: ios-build-release
description: Build, diagnose, and ship iOS apps with xcodebuild and Xcode, including build failures, compiler warnings, simulator hangs, Swift Package Manager resolution, code signing, entitlements in builds, CI pipelines, archives, and release readiness. Use when a build fails or shows warnings, the app crashes or hangs at runtime, packages will not resolve, CI breaks, or a release needs checking. Not for writing tests (use ios-testing) or adopting a new SDK's API changes (use ios-api-availability).
metadata:
  version: "0.3.0"
---

# iOS Build and Release

Produce evidence that the affected build path is healthy and the cause of any failure is understood. Establish evidence before changing code, and match checks to release risk.

Pairs with `ios-testing` for test runs, `ios-api-availability` for SDK upgrades, and the skill that owns the failing code.

## Discover the host project

Read project instructions, the project or workspace, schemes, configurations, build settings, packages, CI configuration, and signing setup. Identify the failing command, destination and OS, first meaningful error, environment prerequisites, and release impact. Do not upgrade Xcode, Swift, the deployment target, or dependencies as incidental repair.

## Select a mode

- **Build failure, warning, crash, or hang:** [diagnosis workflow](references/diagnosis.md). Edit only when a fix is requested.
- **Settings, packages, CI, or release:** [build and release guide](references/xcode-release.md).

## Gotchas

- Put a timeout on simulator and build commands. A stuck CoreSimulatorService makes `xcrun simctl` hang and `xcodebuild` stall at asset-catalog compilation. Run `scripts/pick-simulator.sh` first: it prints a usable iPhone simulator or exits 2 with the recovery command.
- Keep output small: use `-quiet`, and read issues from a result bundle (`-resultBundlePath R.xcresult`, then `xcrun xcresulttool get build-results --path R.xcresult`) instead of scanning raw logs.
- Build with `clean` when counting warnings; incremental builds skip unchanged files and hide their warnings.
- Warnings are part of the result. Fix them at the source; do not silence them with flags or `@available` workarounds.
- `-skipMacroValidation` and `-skipPackagePluginValidation` trust third-party code; ask before adding them.

## Completion contract

- Name a cause only with evidence; separate root cause from symptoms.
- Change the smallest responsible boundary; never mask failures by disabling checks, pinning versions arbitrarily, or blanket retries.
- Rebuild clean and report errors and warnings from the result bundle.
- Report commands, outcomes, skipped checks, prerequisites, and residual risk; a local debug build is not release validation.
