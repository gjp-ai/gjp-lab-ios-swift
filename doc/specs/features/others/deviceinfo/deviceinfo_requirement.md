# Feature: OS & hardware

Status: Implemented

## Goal

Show a read-only snapshot of the iOS version and hardware the app is running on, as a learning sample for reading platform information.

## Scope

### In scope

- iOS details: version, device type, native screen resolution, and interface type.
- Hardware details: model identifier, CPU core count, and physical memory.

### Out of scope

- Live values such as battery, storage, network, or thermal state.
- Device name, identifiers (such as `identifierForVendor`), or any personal data.
- Editing or exporting the values.

## Behavior

- The screen reads the values when it opens and shows them without user action.
- Values do not update while the screen is open.

## UI & Navigation

- Entry point: **Others** category → **OS & hardware** catalogue item.
- Navigation title "OS & hardware", a one-line introduction, and two cards: **iOS** and **Hardware**, each a list of label and value rows.
- Content width is limited on iPad; light and dark appearance and Dynamic Type are supported.

## Rules & Constraints

- Use only public APIs (`UIDevice`, `ProcessInfo`, window scene screen, `uname`).
- Do not read or display device names, identifiers, or anything that identifies the user.
- Do not use deprecated APIs such as `UIScreen.main`; read the screen from the active window scene.

## Platform limitations

- On the simulator, the model identifier is the host architecture (for example `arm64`), not a device model.
- If no window scene is connected, the screen resolution is shown as "Unknown".

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| DEV-AC-01 | Open the screen on an iPhone | iOS version, "iPhone", native resolution, and interface "iPhone" are shown. |
| DEV-AC-02 | Open the screen on an iPad | Device and interface show "iPad". |
| DEV-AC-03 | Hardware card | Model identifier, CPU cores, and memory are shown. |
| DEV-AC-04 | Large text size | Labels and values wrap and stay readable. |

## Technical implementation constraints

- Source lives in `GJPLab/features/others/deviceinfo/`.
- The view does not call platform APIs directly; `DeviceInfoRepository` does.
- No new dependencies.

## Related documents

- [Detailed design](deviceinfo_detail_design.md)
- [Application architecture](../../../../architecture/application.md)
