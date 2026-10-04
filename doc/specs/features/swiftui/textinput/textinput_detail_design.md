# Text & input detailed design

Status: Implemented, with known gaps

Requirements: [Text & input](textinput_requirement.md)

## Implementation goal

A grouped `Form` with three sections. Field values live in a `SignUpForm` value type that also owns the validation rules, so the view only binds fields and reads `problems` and `isValid`.

## Source map

| Source | Responsibility |
| --- | --- |
| [`TextInputScreen.swift`](../../../../../GJPLab/features/swiftui/textinput/TextInputScreen.swift) | Form, focus chaining, keyboard toolbar, submit, and private `SectionHeader` |
| [`SignUpForm.swift`](../../../../../GJPLab/features/swiftui/textinput/SignUpForm.swift) | Name, email, password, `problems`, and `isValid` |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.textInput` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "textInput"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.textInput` to the screen in `feature(for:)` |

## Ownership and state

- `TextInputScreen` owns `form` (`SignUpForm`), `bio`, `note`, and `submittedName` with `@State`, and `focusedField` with `@FocusState` (a private `Field` enum).
- Nothing is persisted or sent; leaving the topic discards everything, including the password.
- The screen uses `Form` instead of `LabDemoPage` because text fields and section footers look native in a form. It applies `.scrollContentBackground(.hidden)` and `.labScreenBackground()` as the theme requires.

## Focus chain

Each field has `.focused($focusedField, equals:)`. `.onSubmit` on Name sets focus to Email, Email to Password, and Password calls `submit()`. `submit()` re-checks `isValid`, clears focus to dismiss the keyboard, and stores the trimmed name to show the confirmation.

## Validation rules

`SignUpForm.problems` returns messages in field order: blank name after trimming whitespace; email not matching the regex `[^@\s]+@[^@\s]+\.[^@\s]+` as a whole match; password shorter than `minimumPasswordLength` (8). The regex is deliberately simple; it rejects obvious mistakes and does not try to implement RFC 5322.

## Character limit

`TextEditor` has no built-in limit, so `.onChange(of: bio)` trims the text to 140 characters with `prefix`. The counter below it reads the current count.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Validation messages show before the user types | The form opens already listing three problems | Show messages only after a field loses focus or after a submit attempt |
| Trimming the bio in `onChange` can move the cursor when pasting long text | The cursor jumps to the end | Accept it for a sample, or use a `TextField` with a custom formatter |
| Confirmation stays visible after editing the form | A stale *Saved* message is shown next to changed values | Clear `submittedName` in `onChange(of: form)` |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUIFeatureTests` checks `SignUpForm` (empty form, valid form, six invalid emails, blank name with short password); `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: TXT-AC-01 to TXT-AC-04 on an iPhone simulator with the software keyboard shown (I/O → Keyboard → Toggle Software Keyboard).
