# GJPLab iOS documentation

This directory documents the iOS lab as it exists today and the behavior it is intended to provide. Source code remains authoritative for implementation; requirement documents are authoritative for intended product behavior.

## Layout

- `architecture/` holds project-wide documents that describe the whole app.
- `specs/` mirrors `GJPLab/` exactly: the docs for `GJPLab/<path>/` live in `doc/specs/<path>/`.
- `templates/` holds the starting point for new requirement and detail design documents.
- `decisions/` records project choices the code alone does not explain, and why they were made.
- `guides/` holds learning material: Swift and SwiftUI tutorials built from this project's code.

```
doc/
├── architecture/application.md           project-wide
├── decisions/                            0001-….md, one per decision
├── guides/                               swift_tutorial.md, swiftui_tutorial.md
├── templates/                            requirement.md, detail_design.md
└── specs/                                mirrors GJPLab/
    ├── app/startup/                      ↔ GJPLab/app/startup/
    │   ├── splash_requirement.md / splash_detail_design.md
    │   └── maintenance_requirement.md / maintenance_detail_design.md
    ├── app/navigation/                   ↔ GJPLab/app/navigation/
    │   ├── sidebar_requirement.md / sidebar_detail_design.md
    │   └── catalog_requirement.md / catalog_detail_design.md
    ├── common/theme/                     ↔ GJPLab/common/theme/
    │   └── theme_detail_design.md        (Slate design system, LabDemoPage)
    ├── common/codesample/                ↔ GJPLab/common/codesample/
    │   └── codesample_requirement.md / codesample_detail_design.md   (runnable sample card)
    └── features/                         ↔ GJPLab/features/
        └── <category>/<feature>/         (for example swift/optionals/, swiftui/layouts/)
            ├── <feature>_requirement.md
            └── <feature>_detail_design.md
```

The `GJPLab/app/` root files are documented in [application architecture](architecture/application.md). `GJPLab/common/config/` holds only constants and has no spec. Testing setup (test plans, UI-testing mode, CI) is described in [application architecture](architecture/application.md#build-and-verification).

`<feature>` is the code folder name (for example `urlsession`, `blockappduringcalls`). Every feature has both a requirement and a detailed design; add them together, starting from [`templates/`](templates/). Shared code with user-facing behavior, such as `common/codesample/`, has both too; shared code without it, such as `common/theme/`, has a detailed design only.

## Document map

| Area | Requirement | Detailed design |
| --- | --- | --- |
| Agent contract | [`AGENTS.md`](../AGENTS.md): project rules, commands, and skill routing | — |
| Application structure | — | [Application architecture](architecture/application.md) |
| Visual system | — | [Slate design system](specs/common/theme/theme_detail_design.md) |
| Runnable code sample | [Code sample requirement](specs/common/codesample/codesample_requirement.md): behavior and acceptance criteria shared by every Swift topic | [Code sample detailed design](specs/common/codesample/codesample_detail_design.md) |
| Decisions | [Decision records](decisions/README.md): why the project is shaped the way it is | — |
| Learning | [Swift tutorial](guides/swift_tutorial.md) and [SwiftUI tutorial](guides/swiftui_tutorial.md): the language and UI features this project uses, with exercises | — |
| Splash (startup) | [Splash requirement](specs/app/startup/splash_requirement.md) | [Splash detailed design](specs/app/startup/splash_detail_design.md) |
| Maintenance (startup) | [Maintenance requirement](specs/app/startup/maintenance_requirement.md) | [Maintenance detailed design](specs/app/startup/maintenance_detail_design.md) |
| Category sidebar | [Sidebar requirement](specs/app/navigation/sidebar_requirement.md) | [Sidebar detailed design](specs/app/navigation/sidebar_detail_design.md) |
| Category catalogue | [Catalogue requirement](specs/app/navigation/catalog_requirement.md) | [Catalogue detailed design](specs/app/navigation/catalog_detail_design.md) |
| Swift → 10 topics | One requirement per topic in [`specs/features/swift/`](specs/features/swift/): [basics](specs/features/swift/basics/basics_requirement.md), [optionals](specs/features/swift/optionals/optionals_requirement.md), [collections](specs/features/swift/collections/collections_requirement.md), [closures](specs/features/swift/closures/closures_requirement.md), [types](specs/features/swift/types/types_requirement.md), [generics](specs/features/swift/generics/generics_requirement.md), [errors](specs/features/swift/errors/errors_requirement.md), [concurrency](specs/features/swift/concurrency/concurrency_requirement.md), [memory](specs/features/swift/memory/memory_requirement.md), [strings](specs/features/swift/strings/strings_requirement.md) | `<topic>_detail_design.md` beside each requirement |
| SwiftUI → 10 topics | One requirement per topic in [`specs/features/swiftui/`](specs/features/swiftui/): [views](specs/features/swiftui/views/views_requirement.md), [layouts](specs/features/swiftui/layouts/layouts_requirement.md), [text input](specs/features/swiftui/textinput/textinput_requirement.md), [buttons](specs/features/swiftui/buttons/buttons_requirement.md), [selection](specs/features/swiftui/selection/selection_requirement.md), [lists](specs/features/swiftui/lists/lists_requirement.md), [navigation](specs/features/swiftui/navigation/navigation_requirement.md), [animation](specs/features/swiftui/animation/animation_requirement.md), [drawing](specs/features/swiftui/drawing/drawing_requirement.md), [accessibility](specs/features/swiftui/accessibility/accessibility_requirement.md) | `<topic>_detail_design.md` beside each requirement |
| HTTP Client → URLSession | [URLSession requirement](specs/features/httpclient/urlsession/urlsession_requirement.md) | [URLSession detailed design](specs/features/httpclient/urlsession/urlsession_detail_design.md) |
| Security → Block App During Calls | [Requirement](specs/features/security/blockappduringcalls/blockappduringcalls_requirement.md) | [Detailed design](specs/features/security/blockappduringcalls/blockappduringcalls_detail_design.md) |
| Integration → Firebase | [Firebase lab requirement](specs/features/integration/firebase/firebase_requirement.md) | [Firebase detailed design](specs/features/integration/firebase/firebase_detail_design.md) |
| Others → OS & hardware | [Requirement](specs/features/others/deviceinfo/deviceinfo_requirement.md) | [Detailed design](specs/features/others/deviceinfo/deviceinfo_detail_design.md) |
| New features | [Requirement template](templates/requirement.md) | [Detail design template](templates/detail_design.md) |

## Reading paths

- **Learning Swift or SwiftUI:** [Swift tutorial](guides/swift_tutorial.md) or [SwiftUI tutorial](guides/swiftui_tutorial.md) → the matching category in the app → that topic's requirement and source.
- **New contributor:** application architecture → decision records → a feature's requirement and detailed design → its Swift sources.
- **Product or QA:** requirements → acceptance scenarios → implementation status in the detailed design.
- **iOS implementation agent:** [`AGENTS.md`](../AGENTS.md) → selected skill → relevant design and requirement documents.

## Documentation contract

Each fact has one owner:

- Requirements describe observable behavior and avoid prescribing SwiftUI types.
- Detailed designs explain how the current iOS implementation satisfies—or does not yet satisfy—requirements.
- Architecture documents stable project-wide boundaries and links to feature details instead of duplicating them.
- Shared behavior (such as the runnable code sample or the demo page rules) is written once in `specs/common/` and linked from each feature, not repeated.
- Integration designs (such as Firebase) document external-service behavior, configuration, and operational risks.

Use repository-relative links and short symbol references rather than copied implementations.

## Status language

| Label | Meaning |
| --- | --- |
| Implemented | Present in source and verifiable from the repository |
| Implemented, with known gaps | Implemented; the detailed design lists gaps that do not break the requirement |
| Partial | Some required behavior exists, with named gaps |
| Planned | Approved requirement with no complete implementation yet |
| Open | Requires product, design, security, or architecture input |

## Maintenance

New feature docs start from the [requirement template](templates/requirement.md) and the [detail design template](templates/detail_design.md), and live at `specs/features/<category>/<feature>/<feature>_requirement.md`, next to `<feature>_detail_design.md`. Follow [Adding a feature](architecture/application.md#adding-a-feature) for the full checklist. When a change reverses or adds a project-wide choice, add a [decision record](decisions/README.md).

Open work is recorded in the **Known gaps** table of each detailed design. List it with `grep -rn -A20 "## Known gaps" doc/specs`, and remove a row in the same change that fixes it.

Update this documentation in the same change when user-visible behavior, routes, state ownership, entitlements, Info.plist permissions, Firebase contracts, build/test commands, the toolchain or deployment target, or material limitations change. Before handoff, verify local Markdown links and report checks that could not run.
