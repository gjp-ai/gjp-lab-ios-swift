# OS & hardware detailed design

Status: Implemented, with known gaps

Requirements: [OS & hardware](deviceinfo_requirement.md)

## Implementation goal

Read platform values once through a small repository and present them as two labeled sections, without identifiers or personal data.

## Source map

| Source | Responsibility |
| --- | --- |
| [`DeviceInfoScreen.swift`](../../../../../GJPLab/features/others/deviceinfo/DeviceInfoScreen.swift) | Screen layout and `InfoSection` cards |
| [`DeviceInfoRepository.swift`](../../../../../GJPLab/features/others/deviceinfo/data/DeviceInfoRepository.swift) | Reads all values; returns `(iOS rows, hardware rows)` |
| [`InfoRow.swift`](../../../../../GJPLab/features/others/deviceinfo/model/InfoRow.swift) | Label and value pair |
| [`FeatureRoute.swift`](../../../../../GJPLab/navigation/FeatureRoute.swift) | `.deviceInfo` route |
| [`DashboardCategory.swift`](../../../../../GJPLab/navigation/catalog/model/DashboardCategory.swift) | Others catalogue entry |

## Data sources

| Row | Source |
| --- | --- |
| iOS version | `UIDevice.current.systemVersion` |
| Device | `UIDevice.current.model` ("iPhone" or "iPad") |
| Screen | `nativeBounds` of the foreground-active window scene's screen (pixels, portrait orientation); "Unknown" if no scene |
| Interface | `userInterfaceIdiom`: "iPad" for `.pad`, otherwise "iPhone" |
| Model | `uname().machine` (for example `iPhone17,1`; `arm64` on the simulator) |
| CPU cores | `ProcessInfo.activeProcessorCount` |
| Memory | `ProcessInfo.physicalMemory`, formatted with `ByteCountFormatter` (memory style) |
| Architecture | Hard-coded "Native" |

The screen reads `UIScreen` through the window scene because `UIScreen.main` is deprecated as of iOS 26.

## Ownership

`DeviceInfoScreen` stores the result of `DeviceInfoRepository().read()` in a `let` property, so the values are read whenever SwiftUI creates the view value. No state is shared or persisted.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| "Architecture" is hard-coded to "Native" | The row carries no information | Show the compiled architecture (for example with `#if arch(arm64)`) or remove the row |
| Interface falls back to "iPhone" for every non-iPad idiom | Mac (Designed for iPad) and visionOS are labeled "iPhone" | Map all `UIUserInterfaceIdiom` cases |
| Simulator shows `arm64` as the model | The model row is misleading in the simulator | Read `SIMULATOR_MODEL_IDENTIFIER` from the environment when running in the simulator |
| `InfoRow.id` is a new `UUID` on every read | Row identity changes whenever the view is recreated | Use the label as the ID |
| The repository is called from a view property initializer | Values are re-read on every view creation | Load once with `.task` into `@State`, or accept the cost (it is small) |
| Repository returns an unnamed tuple | Call sites use `info.0` and `info.1` | Return a small struct with named sections |
| No automated tests | Formatting and fallbacks are unguarded | Unit-test the repository's formatting with injected values |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Manual: open the screen on an iPhone simulator and an iPad simulator (DEV-AC-01 to DEV-AC-03), and at a large Dynamic Type size (DEV-AC-04). Confirm real model identifiers on a physical device.
