# Splash screen requirements

Status: Baseline behavior; iOS implementation is partial

## Objective

Show a recognizable startup experience while resolving whether the user enters the normal application or sees maintenance. Startup remains bounded when Remote Config is unavailable.

## Applicability

These observable rules apply to Android and iOS. Each platform uses native lifecycle, connectivity, accessibility, and navigation conventions while preserving equivalent timing, fallback, race, and destination decisions.

**Feature splash** is the application-owned loading experience after the operating system launch screen. A usable network is a path the platform reports as capable of internet access; a remote request can still fail after that signal.

## Scope

In scope: cold-launch splash, brand and progress presentation, minimum duration, maintenance lookup, timeout and late-result behavior, one transition to main/maintenance, light/dark, text scaling, and reduced-motion behavior.

Out of scope: system launch artwork, authentication, onboarding, consent, update checks, content preloading, destination visual design, and showing the splash during warm resume or ordinary navigation.

## Product decisions

| Decision | Value |
| --- | --- |
| Minimum feature-splash duration | 3 seconds |
| Remote request timeout | 5 seconds after request starts |
| Offline fallback | Maintenance disabled |
| Failed/timed-out request fallback | Maintenance disabled when no accepted value is available |
| Race behavior | First terminal result wins |
| Navigation | Exactly once; splash removed from history |
| Maintenance retry | Allowed without recreating splash |

## Functional requirements

| ID | Requirement |
| --- | --- |
| SPL-FR-01 | Show the feature splash once during a cold launch. |
| SPL-FR-02 | Do not show it during warm resume or after the user enters the app. |
| SPL-FR-03 | Show the approved brand mark, application name, and understandable indeterminate progress state. |
| SPL-FR-04 | Use active light/dark appearance and keep essential content readable at supported text scales and safe areas. |
| SPL-FR-10 | Keep feature splash visible for at least 3 seconds after it becomes visible. |
| SPL-FR-11 | Determine usable internet access before starting Remote Config. |
| SPL-FR-12 | When offline, skip remote request and resolve maintenance as disabled. |
| SPL-FR-13 | When online, request maintenance setting for no more than 5 seconds. |
| SPL-FR-14 | Accept first terminal result or timeout and ignore later completion for startup navigation. |
| SPL-FR-15 | Navigate only after the timing and maintenance-resolution gates complete. |
| SPL-FR-20 | Open maintenance only when the accepted value is enabled; otherwise open dashboard. |
| SPL-FR-21 | Leave splash exactly once and prevent return to it. |
| SPL-FR-22 | Allow retry from maintenance without returning to splash. |

## Acceptance scenarios

| ID | Scenario | Expected result |
| --- | --- | --- |
| SPL-AC-01 | Offline cold launch | No request; splash lasts at least 3 seconds; dashboard opens once. |
| SPL-AC-02 | Disabled result before 3 seconds | Dashboard opens at minimum duration. |
| SPL-AC-03 | Enabled result before 3 seconds | Maintenance opens at minimum duration. |
| SPL-AC-04 | Result between 3 and 5 seconds | Matching destination opens immediately on result. |
| SPL-AC-05 | No result by 5 seconds | Dashboard opens at timeout. |
| SPL-AC-06 | Result after timeout | Existing destination remains unchanged. |
| SPL-AC-07 | Warm resume/back navigation | Feature splash does not reappear. |
| SPL-AC-08 | Light/dark and enlarged text | Approved content remains readable and unclipped. |

## Non-functional requirements

- Startup completion and transition must be idempotent under timeout/result races.
- Essential progress semantics must be exposed to accessibility services.
- Non-essential animation must honor reduced motion.
- Startup must not collect, display, or log personal information.
- Timing, network, remote lookup, presentation, and navigation should remain independently testable where practical.
- Automated tests must use controllable network and Remote Config outcomes rather than production services.

See [the iOS technical design](../features/splash-screen.md) for source evidence and current gaps.
