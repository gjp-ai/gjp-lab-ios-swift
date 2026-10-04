import Foundation

/// Samples for the Collections topic. Each function body is the code shown in its `CodeSample`.
/// Sets and dictionaries have no fixed order, so their output is always sorted before it is logged.
enum CollectionsSamples {
    static let all: [CodeSample] = [
        CodeSample(
            "Arrays",
            explanation: "An array keeps its elements in order and can be changed when it is a var.",
            code: #"""
            var languages = ["Swift", "Kotlin"]
            languages.append("Rust")
            languages.insert("C", at: 0)
            let removed = languages.remove(at: 1)
            log("array: \(languages)")
            log("removed: \(removed), first: \(languages.first ?? "none")")
            log("slice [1...]: \(Array(languages[1...]))")
            """#,
            run: { arrays($0) }
        ),
        CodeSample(
            "Sets",
            explanation: "A set stores unique values with fast membership checks. Its order is not fixed, so sort before showing it.",
            code: #"""
            let ios: Set = ["Swift", "Objective-C", "C"]
            let android: Set = ["Kotlin", "Java", "C"]
            log("both: \(ios.intersection(android).sorted())")
            log("either: \(ios.union(android).sorted())")
            log("iOS only: \(ios.subtracting(android).sorted())")
            log("contains Swift: \(ios.contains("Swift"))")
            """#,
            run: { sets($0) }
        ),
        CodeSample(
            "Dictionaries",
            explanation: "Looking up a key returns an optional, because the key may be missing. default: supplies a starting value.",
            code: #"""
            var stock = ["apple": 3, "pear": 0]
            stock["banana"] = 6
            stock["apple", default: 0] += 2
            log("cherry: \(String(describing: stock["cherry"]))")
            for (fruit, count) in stock.sorted(by: { $0.key < $1.key }) {
                log("\(fruit): \(count)")
            }
            let byLetter = Dictionary(grouping: ["ant", "bee", "bat"]) { String($0.prefix(1)) }
            for (letter, words) in byLetter.sorted(by: { $0.key < $1.key }) {
                log("\(letter): \(words.joined(separator: ", "))")
            }
            """#,
            run: { dictionaries($0) }
        ),
        CodeSample(
            "map, filter, and reduce",
            explanation: "Higher-order functions take a closure and return a new collection or value, leaving the original unchanged.",
            code: #"""
            let scores = [72, 95, 58, 88, 100]
            log("curved: \(scores.map { $0 + 5 })")
            log("passed: \(scores.filter { $0 >= 60 })")
            log("total: \(scores.reduce(0, +))")
            log("sorted: \(scores.sorted(by: >))")
            log("first above 90: \(scores.first(where: { $0 > 90 }) ?? 0)")
            log("numbers: \(["4", "x", "15"].compactMap { Int($0) })")
            log("flattened: \([[1, 2], [3]].flatMap { $0 })")
            """#,
            run: { higherOrderFunctions($0) }
        ),
        CodeSample(
            "Copies are independent",
            explanation: "Arrays are values: changing a copy leaves the original alone. Swift only copies the storage when one of them changes.",
            code: #"""
            let original = [1, 2, 3]
            var copy = original
            copy.append(4)
            log("original: \(original)")
            log("copy: \(copy)")
            """#,
            run: { copies($0) }
        ),
    ]

    static func arrays(_ log: SampleLog) {
        var languages = ["Swift", "Kotlin"]
        languages.append("Rust")
        languages.insert("C", at: 0)
        let removed = languages.remove(at: 1)
        log("array: \(languages)")
        log("removed: \(removed), first: \(languages.first ?? "none")")
        log("slice [1...]: \(Array(languages[1...]))")
    }

    static func sets(_ log: SampleLog) {
        let ios: Set = ["Swift", "Objective-C", "C"]
        let android: Set = ["Kotlin", "Java", "C"]
        log("both: \(ios.intersection(android).sorted())")
        log("either: \(ios.union(android).sorted())")
        log("iOS only: \(ios.subtracting(android).sorted())")
        log("contains Swift: \(ios.contains("Swift"))")
    }

    static func dictionaries(_ log: SampleLog) {
        var stock = ["apple": 3, "pear": 0]
        stock["banana"] = 6
        stock["apple", default: 0] += 2
        log("cherry: \(String(describing: stock["cherry"]))")
        for (fruit, count) in stock.sorted(by: { $0.key < $1.key }) {
            log("\(fruit): \(count)")
        }
        let byLetter = Dictionary(grouping: ["ant", "bee", "bat"]) { String($0.prefix(1)) }
        for (letter, words) in byLetter.sorted(by: { $0.key < $1.key }) {
            log("\(letter): \(words.joined(separator: ", "))")
        }
    }

    static func higherOrderFunctions(_ log: SampleLog) {
        let scores = [72, 95, 58, 88, 100]
        log("curved: \(scores.map { $0 + 5 })")
        log("passed: \(scores.filter { $0 >= 60 })")
        log("total: \(scores.reduce(0, +))")
        log("sorted: \(scores.sorted(by: >))")
        log("first above 90: \(scores.first(where: { $0 > 90 }) ?? 0)")
        log("numbers: \(["4", "x", "15"].compactMap { Int($0) })")
        log("flattened: \([[1, 2], [3]].flatMap { $0 })")
    }

    static func copies(_ log: SampleLog) {
        let original = [1, 2, 3]
        var copy = original
        copy.append(4)
        log("original: \(original)")
        log("copy: \(copy)")
    }
}
