# 0001: Command-line builds use `build/DerivedData`

Status: Accepted, 2026-10-03

## Context

A command-line `xcodebuild` failed in the Firebase package step (`SwiftDriver FirebaseRemoteConfigInterop`) while Xcode was open on the same project. Both were building into the default DerivedData folder and overwrote each other's intermediate files. Quitting Xcode fixed it, but that is easy to forget.

## Decision

Every documented command-line build and test passes `-derivedDataPath build/DerivedData`. Xcode keeps using its own default DerivedData. `build/` is git-ignored.

## Consequences

- Xcode and the terminal (including agents) can build at the same time.
- The first command-line build compiles all packages, including Firebase, from scratch; later builds are incremental.
- Disk use roughly doubles, because the two locations hold separate build products. Delete `build/` to reclaim it.
- New commands in `AGENTS.md`, `README.md`, and `doc/architecture/application.md` must include the flag.
