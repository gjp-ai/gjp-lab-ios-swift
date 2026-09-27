# Xcode, dependencies, CI, and release

## Make scoped build changes

- Inspect project settings, schemes, configurations, packages, deployment target, capabilities, entitlements, and CI before changing versions or target configuration.
- Change only the dependencies or settings the outcome needs. Check official release notes when versions may have changed.
- Do not regenerate signing material, expose credentials, alter provisioning, or archive/publish a release without explicit authorization.

## Verify in increasing scope

1. Focused build, unit test, or `xcodebuild -resolvePackageDependencies`.
2. The affected scheme and configuration, with `CODE_SIGNING_ALLOWED=NO` for local compilation where appropriate.
3. Simulator tests on a concrete destination (`scripts/pick-simulator.sh`; see `ios-testing`); a device for platform-fidelity behavior.
4. CI or archive checks when shared build logic, signing, packaging, entitlements, privacy manifests, or release configuration changed.

Use `-resultBundlePath` and `xcrun xcresulttool get build-results|test-results` to report results. Inspect generated Info.plist, compiled asset catalogs, signed entitlements, archive contents, and resolved packages when they decide correctness.

## CI

- Commit `Package.resolved` and build with `-disableAutomaticPackageResolution` so CI uses reviewed versions.
- Pin the Xcode version and simulator runtime; select a destination at runtime instead of hard-coding a device that may not exist.
- `-skipMacroValidation` and `-skipPackagePluginValidation` trust third-party code; ask before adding them.
- Isolate DerivedData per job (`-derivedDataPath`) when caching causes stale results.

## Release readiness

- Check version and build numbers, deployment target, privacy usage descriptions, privacy manifests, entitlement and capability alignment, ATS, startup performance, and upgrade compatibility as relevant.
- Keep debug logging, development endpoints, tokens, test menus, and SDK debug configuration out of release artifacts.
- Report skipped environment-specific checks; a local debug build is not release validation.
