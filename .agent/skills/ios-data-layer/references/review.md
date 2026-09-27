# Data-layer review

Report findings without editing unless a fix is requested. Order them by data loss, user-visible failure, security exposure, then resource risk.

## Contract

- [ ] Each value has one source of truth; callers know whether they get a snapshot or an observed value.
- [ ] Failures are actionable; cancellation is not reported as an error.
- [ ] HTTP status codes and empty bodies are handled.

## Storage and caching

- [ ] Freshness, invalidation, and conflict resolution are defined for caches and synced data.
- [ ] Schema changes include a tested migration; existing user data is preserved.
- [ ] Secrets are in the Keychain, not `UserDefaults`, files, or logs.
- [ ] No repeated loads or duplicate observation on view re-entry.

## Boundaries

- [ ] SDK and transport types do not leak into feature state.
- [ ] Retries are bounded and skip permanent failures (authorization, validation).
- [ ] Tests use fakes, in-memory stores, or per-test `URLProtocol` stubs, never live services.
