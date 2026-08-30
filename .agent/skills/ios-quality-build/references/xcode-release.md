# Xcode, dependencies, CI, and release

## Make scoped build changes

- Inspect project/workspace settings, schemes, build configurations, Swift packages, deployment target, capabilities, entitlements, and CI before changing versions or target configuration.
- Change only dependencies or settings needed for the outcome. Verify compatibility in official release notes or documentation when versions may have changed.
- Do not regenerate signing material, expose credentials, alter provisioning, or publish/archive a release without explicit authorization.

## Verify in increasing scope

1. Run the focused build, unit test, or package-resolution command.
2. Build the affected scheme/configuration with code signing disabled where appropriate for local compilation.
3. Run simulator tests when a runtime is available; use a device for platform-fidelity behavior.
4. Exercise CI/archive checks when shared build logic, signing, packaging, entitlements, privacy manifests, or release configuration changed.

Inspect generated Info.plist, compiled asset catalogs, signed entitlements, archive contents, and resolved packages when those artifacts determine correctness.

## Release readiness

- Check versioning, deployment target, privacy usage descriptions, entitlement/capability alignment, ATS, required-reason APIs, startup performance, and upgrade compatibility as relevant.
- Ensure debug logging, development endpoints, tokens, test menus, and Firebase debug configuration do not enter release artifacts.
- Report skipped environment-specific checks; a local debug build is not release validation.
