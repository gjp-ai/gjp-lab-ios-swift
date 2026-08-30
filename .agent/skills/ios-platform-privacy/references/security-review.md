# Platform privacy and security review

- Review URL/deep-link input, universal links, pasteboard, share sheets, file URLs, web views, notification content, app groups, keychain use, screenshots, logging, backups, and debug-only configuration.
- Trace credentials, tokens, identifiers, location, media, and personal data through storage, transport, analytics, Crashlytics, clipboard, files, and sharing.
- Check ATS exceptions, TLS handling, certificate pinning if present, temporary files, keychain accessibility, and privacy manifests or required-reason APIs where applicable.
- Confirm signing identities, provisioning profiles, APNs keys, service-account material, OAuth credentials, and debug tokens are not committed or surfaced.
- Report exploitable exposure or unintended collection first, with entry point, data/capability, preconditions, and proportionate remediation. Do not claim platform guarantees that were not verified.
