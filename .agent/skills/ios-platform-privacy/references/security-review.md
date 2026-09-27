# Platform privacy and security review

Report exploitable exposure or unintended collection first, with entry point, data or capability, preconditions, and proportionate fix. Do not claim platform guarantees you did not verify.

## Inputs

- [ ] URL schemes, universal links, user activities, and notification payloads are validated before use.
- [ ] Pasteboard, share sheets, file URLs, and web views do not accept or expose more than intended.

## Data at rest and in transit

- [ ] Credentials and tokens live in the Keychain with an appropriate accessibility class.
- [ ] Personal data is traced through storage, backups, app groups, analytics, crash reporting, and logs.
- [ ] No ATS exceptions or custom trust handling without a documented reason; pinning, if present, has a rotation plan.
- [ ] Temporary files and screenshots of sensitive screens are handled.

## Configuration and artifacts

- [ ] Privacy manifest covers required-reason APIs and collected data; SDK manifests are present.
- [ ] Entitlements match per configuration; no unused capabilities.
- [ ] No signing identities, provisioning profiles, APNs keys, service-account files, OAuth secrets, or debug tokens in the repository or build artifacts.
- [ ] Debug-only settings and endpoints are excluded from release builds.
