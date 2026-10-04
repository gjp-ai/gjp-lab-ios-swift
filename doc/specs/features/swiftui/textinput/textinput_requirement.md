# Feature: Text & input

Status: Implemented

## Goal

Show text display (Markdown, formatting, truncation) and text entry with focus management and validation.

## Scope

### In scope

- `Text` with Markdown, locale-aware date and currency formatting, and `.lineLimit`.
- A sign-up form: name, email, and password fields chained with `@FocusState` and `.onSubmit`.
- Validation messages and a disabled submit button until the form is valid.
- A growing vertical `TextField` and a `TextEditor` with a 140-character limit and counter.
- A keyboard toolbar **Done** button and interactive keyboard dismissal on scroll.

### Out of scope

- Sending or storing the form anywhere; success is shown locally only.
- Rich text editing and `AttributedString` editing.

## Behavior

- Return in Name moves focus to Email, Email to Password, and Password submits.
- Validation rules (in `SignUpForm`): name not blank; email matches `x@y.z` without spaces; password at least 8 characters.
- Submitting a valid form clears focus and shows a confirmation naming the user; nothing leaves the device.
- Typing past 140 characters in the bio is trimmed to 140.

## UI & Navigation

- Entry point: **SwiftUI** category → **Text & input** catalogue item (route `textInput`).
- A grouped `Form` with sections **Text**, **Text fields and focus**, and **Multi-line input**; headers and footers use `onSurfaceVariant`.
- The email field uses the email keyboard with autocapitalization and autocorrection off; the password uses `SecureField` and the new-password content type.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- The shared [demo page rules](../../../common/theme/theme_detail_design.md#demo-pages) apply: public SwiftUI APIs on the deployment target only, sample data kept in memory (nothing persisted, sent, or logged), and `LabTheme` colours.
- Do not log or persist entered values, especially the password.

## Platform limitations

- The software keyboard does not appear in the simulator when a hardware keyboard is connected; the keyboard toolbar is then hidden.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| TXT-AC-01 | Open the screen | Three validation messages are shown and **Create account** is disabled. |
| TXT-AC-02 | Enter a valid name, email, and 8-character password | Messages disappear and the button is enabled. |
| TXT-AC-03 | Press Return in each field | Focus moves Name → Email → Password, then submits. |
| TXT-AC-04 | Type more than 140 characters in the bio | Text stops at 140 and the counter reads 140 of 140. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/textinput/` (`TextInputScreen.swift`, `SignUpForm.swift`).
- `FeatureRoute.textInput` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "textInput"`.
- No new dependencies.

## Related documents

- [Detailed design](textinput_detail_design.md)
- [Slate design system: demo pages](../../../common/theme/theme_detail_design.md#demo-pages) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
