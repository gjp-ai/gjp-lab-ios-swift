import Foundation

/// The values typed into the Text & input sample form, and the rules that decide whether it can be submitted.
/// Validation lives here instead of in the view so unit tests can check it.
struct SignUpForm {
    var name = ""
    var email = ""
    var password = ""

    static let minimumPasswordLength = 8

    /// One message per rule that is not yet met, in field order. Empty when the form is valid.
    var problems: [String] {
        var problems: [String] = []
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            problems.append("Enter your name.")
        }
        if email.wholeMatch(of: /[^@\s]+@[^@\s]+\.[^@\s]+/) == nil {
            problems.append("Enter an email address such as name@example.com.")
        }
        if password.count < Self.minimumPasswordLength {
            problems.append("Use at least \(Self.minimumPasswordLength) characters for the password.")
        }
        return problems
    }

    var isValid: Bool { problems.isEmpty }
}
