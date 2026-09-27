# Feature: Maintenance

Status: Implemented

## Goal

Tell users clearly when GJP Lab is temporarily unavailable, and let them check again without restarting the app.

## Scope

### In scope

- The maintenance screen shown after startup when the maintenance flag is enabled.
- Retrying the maintenance check from that screen.

### Out of scope

- Deciding at launch whether to show maintenance, and the timing and fallback rules for that decision (owned by the [splash requirement](splash_requirement.md), SPL-FR-10 to SPL-FR-22).
- Switching an already-running app into maintenance.
- Scheduled maintenance windows, status pages, or messages supplied by the server.

## Behavior

- Maintenance appears only when startup resolves the remote maintenance flag as enabled.
- **Try again** requests the maintenance flag again, with the same 5-second limit as startup.
- If the flag is now disabled, or the request fails or times out, the dashboard opens. If it is still enabled, the maintenance screen stays.
- Retrying never returns to the splash screen.

## UI & Navigation

- Full-screen content with no navigation bar and no way back: a maintenance icon, the title "We'll be back soon", an explanation, and a **Try again** button.
- Content is centered and width-limited on iPad, and supports light and dark appearance and Dynamic Type.

## Rules & Constraints

- The maintenance flag is the Remote Config key `gjp_lab_maintenance_enabled`, with a local default of `false`.
- A failed or timed-out check fails open to the dashboard, matching startup behavior.
- The screen shows no personal data and logs nothing.

## Platform limitations

- In release builds Remote Config serves a cached value for up to one hour, so a retry may keep showing maintenance for up to an hour after it is turned off.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| MNT-AC-01 | Startup resolves maintenance as enabled | The maintenance screen appears; the dashboard is not reachable. |
| MNT-AC-02 | Maintenance is turned off, then the user taps **Try again** | The dashboard opens. |
| MNT-AC-03 | Maintenance is still on and the user taps **Try again** | The maintenance screen stays. |
| MNT-AC-04 | The network is unavailable and the user taps **Try again** | The dashboard opens (fail open). |
| MNT-AC-05 | Dark appearance and a large text size | All content is readable and the button is reachable. |

## Technical implementation constraints

- Source lives in `GJPLab/app/startup/`; the retry decision stays with the app-level startup state in `GJPLabApp`.
- Remote Config access goes through `FirebaseIntegration`; the key is defined in `FirebaseConstants`.
- No new dependencies.

## Related documents

- [Detailed design](maintenance_detail_design.md)
- [Splash requirement](splash_requirement.md)
- [Firebase detailed design](../../features/integration/firebase/firebase_detail_design.md)
