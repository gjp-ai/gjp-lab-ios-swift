# Decision records

Short notes on project choices that the code alone does not explain. Read them before reversing one of these choices; write a new record (rather than editing an old one) when a decision changes.

## Format

File name: `NNNN-short-title.md`, numbered in order. Each record has:

- **Status:** Accepted, or Superseded by a later record (with a link).
- **Context:** the problem and the forces at play.
- **Decision:** what was chosen.
- **Consequences:** what becomes easier, what becomes harder, and the rules that follow.

## Records

| # | Decision | Date |
| --- | --- | --- |
| [0001](0001-separate-derived-data-for-cli-builds.md) | Command-line builds use `build/DerivedData` | 2026-10-03 |
| [0002](0002-flat-feature-folders.md) | One flat folder per feature and per app area | 2026-10-03 |
| [0003](0003-sdk-code-in-integration-features.md) | SDK code lives in `features/integration/<sdk>/` | 2026-10-03 |
| [0004](0004-navigation-menu-in-json.md) | Sidebar and catalogue content in `navigation.json`; routes stay in Swift | 2026-10-03 |
