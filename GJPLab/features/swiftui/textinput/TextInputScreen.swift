import SwiftUI

struct TextInputScreen: View {
    private enum Field: Hashable {
        case name, email, password, bio
    }

    @State private var form = SignUpForm()
    @State private var bio = ""
    @State private var note = ""
    @State private var submittedName: String?
    @FocusState private var focusedField: Field?

    private let bioLimit = 140

    var body: some View {
        Form {
            Section {
                Text("**Bold**, *italic*, `code`, and a [link](https://developer.apple.com/documentation/swiftui/text)")
                Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide).year())
                Text(1234.5, format: .currency(code: "USD"))
                Text("A long line that stops after one line and ends with an ellipsis because of .lineLimit(1).")
                    .lineLimit(1)
            } header: {
                SectionHeader("Text")
            } footer: {
                Text("A string literal in Text supports Markdown; values use format styles that follow the user's locale.")
                    .foregroundStyle(LabTheme.onSurfaceVariant)
            }

            Section {
                TextField("Name", text: $form.name)
                    .textContentType(.name)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .name)
                    .onSubmit { focusedField = .email }
                TextField("Email", text: $form.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit { focusedField = .password }
                SecureField("Password", text: $form.password)
                    .textContentType(.newPassword)
                    .submitLabel(.done)
                    .focused($focusedField, equals: .password)
                    .onSubmit(submit)

                if !form.problems.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(form.problems, id: \.self) { problem in
                            Label(problem, systemImage: "exclamationmark.circle")
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                }

                Button("Create account", action: submit)
                    .buttonStyle(.labPrimary)
                    .disabled(!form.isValid)
                    .frame(maxWidth: .infinity)

                if let submittedName {
                    Label("Saved locally for \(submittedName). Nothing is sent anywhere.", systemImage: "checkmark.circle")
                        .foregroundStyle(LabTheme.success)
                }
            } header: {
                SectionHeader("Text fields and focus")
            } footer: {
                Text("Return moves to the next field with @FocusState. The button stays disabled until every rule passes.")
                    .foregroundStyle(LabTheme.onSurfaceVariant)
            }

            Section {
                TextField("Short note that grows to four lines", text: $note, axis: .vertical)
                    .lineLimit(1...4)
                TextEditor(text: $bio)
                    .frame(minHeight: 100)
                    .focused($focusedField, equals: .bio)
                    .scrollContentBackground(.hidden)
                    .onChange(of: bio) { _, newValue in
                        if newValue.count > bioLimit { bio = String(newValue.prefix(bioLimit)) }
                    }
                    .accessibilityLabel("Bio")
                Text("\(bio.count) of \(bioLimit) characters")
                    .font(.footnote)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
            } header: {
                SectionHeader("Multi-line input")
            }
        }
        .scrollContentBackground(.hidden)
        .labScreenBackground()
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .navigationTitle("Text & input")
    }

    private func submit() {
        guard form.isValid else { return }
        focusedField = nil
        submittedName = form.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// `.labScreenBackground()` makes text `onSurface`, so headers set `onSurfaceVariant` to keep the Form's hierarchy.
private struct SectionHeader: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title).foregroundStyle(LabTheme.onSurfaceVariant)
    }
}

#Preview("Text & input – light") {
    NavigationStack { TextInputScreen() }
}

#Preview("Text & input – dark") {
    NavigationStack { TextInputScreen() }
        .preferredColorScheme(.dark)
}
