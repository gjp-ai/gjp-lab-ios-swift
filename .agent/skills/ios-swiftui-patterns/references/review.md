# SwiftUI review

Review without editing unless changes are requested. Report only actionable findings, ordered by user impact, each with the code path, consequence, trigger, and smallest safe fix. If nothing material remains, say so and list unverified paths. Do not require a view model, coordinator, or custom design system because it is common elsewhere.

## Structure and state

- [ ] Each screen traces from its navigation entry and state owner through effects and callbacks.
- [ ] Async work is tied to view lifetime (`.task`), and identity is stable in lists and conditionals.
- [ ] No network, storage, SDK, or platform work in leaf views; no mutation while computing `body`.

## Visual and platform

- [ ] Semantic colors and standard controls; light and dark appearance both work.
- [ ] Safe areas, keyboard, and supported window sizes are handled once at the owning layout.
- [ ] Reachable loading, empty, failure, and disabled states are represented.

## Accessibility and text

- [ ] Labels for icon-only controls; decorative images hidden; focus order logical.
- [ ] Dynamic Type at large sizes without clipping; status not conveyed by color alone.
- [ ] User-facing text is localizable; leading and trailing layout.

## Verification

- [ ] Previews cover meaningful states and appearances; UI tests use identifiers, not visible text.
