import Foundation

/// Samples for the Optionals topic. Each function body is the code shown in its `CodeSample`.
enum OptionalsSamples {
    static let all: [CodeSample] = [
        CodeSample(
            "Optional values",
            explanation: "An optional holds either a value or nil. Int(String) returns one, because the text may not be a number.",
            code: #"""
            let number: Int? = Int("42")
            let invalid: Int? = Int("forty-two")
            log("Int(\"42\") = \(String(describing: number))")
            log("Int(\"forty-two\") = \(String(describing: invalid))")
            """#,
            run: { optionalValues($0) }
        ),
        CodeSample(
            "if let",
            explanation: "if let unwraps the value only inside its braces; the else branch handles nil.",
            code: #"""
            func greet(_ nickname: String?) -> String {
                if let nickname {
                    return "Hello, \(nickname)!"
                } else {
                    return "Hello, guest!"
                }
            }
            log(greet("Ada"))
            log(greet(nil))
            """#,
            run: { ifLet($0) }
        ),
        CodeSample(
            "guard let",
            explanation: "guard let exits early on nil, so the rest of the function uses the unwrapped value.",
            code: #"""
            func nextAge(from text: String) -> String {
                guard let age = Int(text) else {
                    return "\"\(text)\" is not a number"
                }
                return "Next year you will be \(age + 1)"
            }
            log(nextAge(from: "36"))
            log(nextAge(from: "abc"))
            """#,
            run: { guardLet($0) }
        ),
        CodeSample(
            "?? and optional chaining",
            explanation: "?. stops at the first nil and returns nil; ?? supplies a default.",
            code: #"""
            struct Address { var city: String? }
            struct User { var address: Address? }
            let resident = User(address: Address(city: "Singapore"))
            let visitor = User(address: nil)
            log("city: \(resident.address?.city ?? "unknown")")
            log("city: \(visitor.address?.city ?? "unknown")")
            log("letters: \(String(describing: resident.address?.city?.count))")
            """#,
            run: { chaining($0) }
        ),
        CodeSample(
            "map and flatMap",
            explanation: "map transforms a value if there is one; flatMap does the same when the transform also returns an optional.",
            code: #"""
            func doubled(_ text: String?) -> Int? {
                text.flatMap { Int($0) }.map { $0 * 2 }
            }
            log("\"8\" → \(String(describing: doubled("8")))")
            log("\"x\" → \(String(describing: doubled("x")))")
            log("nil → \(String(describing: doubled(nil)))")
            """#,
            run: { mapAndFlatMap($0) }
        ),
        CodeSample(
            "Force unwrapping",
            explanation: "! stops the app when the value is nil. This sample explains the crash and runs the safe version.",
            code: #"""
            let stock = ["apple": 3]
            // let pears = stock["pear"]!  ← stops the app:
            //   "Unexpectedly found nil while unwrapping an Optional value"
            let pears = stock["pear"] ?? 0
            log("stock[\"pear\"] ?? 0 = \(pears)")
            log("Use ! only when nil is impossible, and say why in a comment.")
            """#,
            run: { forceUnwrapping($0) }
        ),
    ]

    static func optionalValues(_ log: SampleLog) {
        let number: Int? = Int("42")
        let invalid: Int? = Int("forty-two")
        log("Int(\"42\") = \(String(describing: number))")
        log("Int(\"forty-two\") = \(String(describing: invalid))")
    }

    static func ifLet(_ log: SampleLog) {
        func greet(_ nickname: String?) -> String {
            if let nickname {
                return "Hello, \(nickname)!"
            } else {
                return "Hello, guest!"
            }
        }
        log(greet("Ada"))
        log(greet(nil))
    }

    static func guardLet(_ log: SampleLog) {
        func nextAge(from text: String) -> String {
            guard let age = Int(text) else {
                return "\"\(text)\" is not a number"
            }
            return "Next year you will be \(age + 1)"
        }
        log(nextAge(from: "36"))
        log(nextAge(from: "abc"))
    }

    static func chaining(_ log: SampleLog) {
        struct Address { var city: String? }
        struct User { var address: Address? }
        let resident = User(address: Address(city: "Singapore"))
        let visitor = User(address: nil)
        log("city: \(resident.address?.city ?? "unknown")")
        log("city: \(visitor.address?.city ?? "unknown")")
        log("letters: \(String(describing: resident.address?.city?.count))")
    }

    static func mapAndFlatMap(_ log: SampleLog) {
        func doubled(_ text: String?) -> Int? {
            text.flatMap { Int($0) }.map { $0 * 2 }
        }
        log("\"8\" → \(String(describing: doubled("8")))")
        log("\"x\" → \(String(describing: doubled("x")))")
        log("nil → \(String(describing: doubled(nil)))")
    }

    static func forceUnwrapping(_ log: SampleLog) {
        let stock = ["apple": 3]
        // let pears = stock["pear"]!  ← stops the app:
        //   "Unexpectedly found nil while unwrapping an Optional value"
        let pears = stock["pear"] ?? 0
        log("stock[\"pear\"] ?? 0 = \(pears)")
        log("Use ! only when nil is impossible, and say why in a comment.")
    }
}
