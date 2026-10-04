import Foundation

/// Samples for the Functions & closures topic. Each function body is the code shown in its `CodeSample`.
enum ClosuresSamples {
    static let all: [CodeSample] = [
        CodeSample(
            "Labels and default values",
            explanation: "Argument labels make calls read like sentences; default values let callers leave arguments out.",
            code: #"""
            func greet(_ name: String, from city: String = "Singapore", times: Int = 1) -> String {
                Array(repeating: "Hi \(name) from \(city)!", count: times).joined(separator: " ")
            }
            log(greet("Ada"))
            log(greet("Linus", from: "Helsinki"))
            log(greet("Grace", times: 2))
            """#,
            run: { labelsAndDefaults($0) }
        ),
        CodeSample(
            "Variadic and inout parameters",
            explanation: "A variadic parameter accepts any number of values. inout lets a function change the caller's variable, marked with &.",
            code: #"""
            func average(_ numbers: Double...) -> Double {
                numbers.isEmpty ? 0 : numbers.reduce(0, +) / Double(numbers.count)
            }
            func double(_ value: inout Int) {
                value *= 2
            }
            log("average(2, 4, 9) = \(average(2, 4, 9))")
            var level = 5
            double(&level)
            log("level after double(&level): \(level)")
            """#,
            run: { variadicAndInout($0) }
        ),
        CodeSample(
            "Functions as values",
            explanation: "A function has a type, such as (String) -> String, so it can be passed to another function.",
            code: #"""
            func shout(_ text: String) -> String { text.uppercased() + "!" }
            func whisper(_ text: String) -> String { text.lowercased() + "…" }
            func apply(_ style: (String) -> String, to text: String) -> String {
                style(text)
            }
            log(apply(shout, to: "Hello"))
            log(apply(whisper, to: "Hello"))
            """#,
            run: { functionsAsValues($0) }
        ),
        CodeSample(
            "Closure shorthand",
            explanation: "The same closure written from its full form to its shortest; all four sort the same way.",
            code: #"""
            let names = ["Chris", "Alex", "Ewa", "Barry"]
            let full = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 < s2 })
            let inferred = names.sorted(by: { s1, s2 in s1 < s2 })
            let shorthand = names.sorted { $0 < $1 }
            let operatorOnly = names.sorted(by: <)
            log("full: \(full)")
            log("inferred: \(inferred)")
            log("shorthand: \(shorthand)")
            log("operator: \(operatorOnly)")
            """#,
            run: { closureShorthand($0) }
        ),
        CodeSample(
            "Capturing values",
            explanation: "A closure keeps the variables it uses alive. Each counter captures its own count.",
            code: #"""
            func makeCounter() -> () -> Int {
                var count = 0
                return {
                    count += 1
                    return count
                }
            }
            let first = makeCounter()
            let second = makeCounter()
            log("first: \(first()), \(first()), \(first())")
            log("second: \(second()), \(second())")
            """#,
            run: { capturingValues($0) }
        ),
        CodeSample(
            "Escaping closures",
            explanation: "@escaping marks a closure that is stored and called after the function returns, such as a completion handler.",
            code: #"""
            var handlers: [() -> String] = []
            func register(_ name: String, handler: @escaping () -> String) {
                handlers.append(handler)
                log("registered \(name)")
            }
            register("a") { "handler a ran" }
            register("b") { "handler b ran" }
            for handler in handlers {
                log(handler())
            }
            """#,
            run: { escapingClosures($0) }
        ),
    ]

    static func labelsAndDefaults(_ log: SampleLog) {
        func greet(_ name: String, from city: String = "Singapore", times: Int = 1) -> String {
            Array(repeating: "Hi \(name) from \(city)!", count: times).joined(separator: " ")
        }
        log(greet("Ada"))
        log(greet("Linus", from: "Helsinki"))
        log(greet("Grace", times: 2))
    }

    static func variadicAndInout(_ log: SampleLog) {
        func average(_ numbers: Double...) -> Double {
            numbers.isEmpty ? 0 : numbers.reduce(0, +) / Double(numbers.count)
        }
        func double(_ value: inout Int) {
            value *= 2
        }
        log("average(2, 4, 9) = \(average(2, 4, 9))")
        var level = 5
        double(&level)
        log("level after double(&level): \(level)")
    }

    static func functionsAsValues(_ log: SampleLog) {
        func shout(_ text: String) -> String { text.uppercased() + "!" }
        func whisper(_ text: String) -> String { text.lowercased() + "…" }
        func apply(_ style: (String) -> String, to text: String) -> String {
            style(text)
        }
        log(apply(shout, to: "Hello"))
        log(apply(whisper, to: "Hello"))
    }

    static func closureShorthand(_ log: SampleLog) {
        let names = ["Chris", "Alex", "Ewa", "Barry"]
        let full = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 < s2 })
        let inferred = names.sorted(by: { s1, s2 in s1 < s2 })
        let shorthand = names.sorted { $0 < $1 }
        let operatorOnly = names.sorted(by: <)
        log("full: \(full)")
        log("inferred: \(inferred)")
        log("shorthand: \(shorthand)")
        log("operator: \(operatorOnly)")
    }

    static func capturingValues(_ log: SampleLog) {
        func makeCounter() -> () -> Int {
            var count = 0
            return {
                count += 1
                return count
            }
        }
        let first = makeCounter()
        let second = makeCounter()
        log("first: \(first()), \(first()), \(first())")
        log("second: \(second()), \(second())")
    }

    static func escapingClosures(_ log: SampleLog) {
        var handlers: [() -> String] = []
        func register(_ name: String, handler: @escaping () -> String) {
            handlers.append(handler)
            log("registered \(name)")
        }
        register("a") { "handler a ran" }
        register("b") { "handler b ran" }
        for handler in handlers {
            log(handler())
        }
    }
}
