# Authorization workflow

## Minimize the request

- Confirm a system picker, limited access, delegated controller, or less-sensitive API cannot meet the need first.
- Add the exact `Info.plist` usage description and entitlement only when the feature requires them. Keep authorization checks next to the protected operation.

## Design the user flow

- Ask in context after the user initiates a feature, with an explanation of its benefit before the system sheet.
- Handle not-determined, denied, restricted, limited, provisional, revoked, unavailable, and missing-entitlement states as applicable.
- Keep the feature useful when possible without access. Do not loop prompts or pressure users toward Settings.
- Use the capability's current authorization status immediately before the protected action; prior grants can change.

## Verify

- Test first request, grant, denial, settings change, interrupted prompt, and relevant OS versions on a device when framework fidelity matters.
- Inspect generated Info.plist and signed entitlements so privacy strings and capabilities match the actual target.
