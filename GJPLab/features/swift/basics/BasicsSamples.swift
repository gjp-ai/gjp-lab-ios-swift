import Foundation

/// Samples for the Values & types topic. Each function body is the code shown in its `CodeSample`.
enum BasicsSamples {
    static let all: [CodeSample] = [
        CodeSample(
            "Constants and variables",
            explanation: "let makes a constant that never changes; var makes a variable.",
            code: #"""
            let maximumScore = 100
            var score = 40
            score += 25
            log("score: \(score) of \(maximumScore)")
            // maximumScore = 120  ← error: cannot assign to a 'let' constant
            log("let values cannot change after they are set")
            """#,
            run: { constantsAndVariables($0) }
        ),
        CodeSample(
            "Type inference",
            explanation: "Swift works out each type from the value. An annotation chooses a different type.",
            code: #"""
            let count = 42
            let price = 3.5
            let name = "Swift"
            let isReady = true
            let explicit: Double = 42
            log("\(count): \(type(of: count))")
            log("\(price): \(type(of: price))")
            log("\(name): \(type(of: name))")
            log("\(isReady): \(type(of: isReady))")
            log("\(explicit): \(type(of: explicit))")
            """#,
            run: { typeInference($0) }
        ),
        CodeSample(
            "Numbers and conversion",
            explanation: "Int and Double never mix silently: convert one explicitly. Int division drops the fraction.",
            code: #"""
            let apples = 7
            let people = 2
            log("Int division: \(apples / people)")
            log("remainder: \(apples % people)")
            log("Double division: \(Double(apples) / Double(people))")
            // apples / 2.5  ← error: Int and Double cannot be mixed
            log("Int(3.99) = \(Int(3.99)), rounded = \(Int(3.99.rounded()))")
            """#,
            run: { numbersAndConversion($0) }
        ),
        CodeSample(
            "Overflow",
            explanation: "Plain + stops the app when a result does not fit. &+ wraps around instead.",
            code: #"""
            let largest = Int8.max
            log("Int8.max = \(largest)")
            log("Int8.max &+ 1 = \(largest &+ 1)")
            // largest + 1  ← stops the app: arithmetic overflow
            let (sum, overflow) = largest.addingReportingOverflow(1)
            log("addingReportingOverflow: \(sum), overflow: \(overflow)")
            """#,
            run: { overflow($0) }
        ),
        CodeSample(
            "Tuples",
            explanation: "A tuple groups a few values without declaring a type, and can be split into constants.",
            code: #"""
            let response = (code: 404, message: "Not Found")
            log("code: \(response.code), message: \(response.message)")
            let (code, message) = response
            log("destructured: \(code) \(message)")
            func minMax(_ values: [Int]) -> (min: Int, max: Int) {
                (values.min() ?? 0, values.max() ?? 0)
            }
            let range = minMax([7, 2, 9, 4])
            log("min \(range.min), max \(range.max)")
            """#,
            run: { tuples($0) }
        ),
    ]

    static func constantsAndVariables(_ log: SampleLog) {
        let maximumScore = 100
        var score = 40
        score += 25
        log("score: \(score) of \(maximumScore)")
        // maximumScore = 120  ← error: cannot assign to a 'let' constant
        log("let values cannot change after they are set")
    }

    static func typeInference(_ log: SampleLog) {
        let count = 42
        let price = 3.5
        let name = "Swift"
        let isReady = true
        let explicit: Double = 42
        log("\(count): \(type(of: count))")
        log("\(price): \(type(of: price))")
        log("\(name): \(type(of: name))")
        log("\(isReady): \(type(of: isReady))")
        log("\(explicit): \(type(of: explicit))")
    }

    static func numbersAndConversion(_ log: SampleLog) {
        let apples = 7
        let people = 2
        log("Int division: \(apples / people)")
        log("remainder: \(apples % people)")
        log("Double division: \(Double(apples) / Double(people))")
        // apples / 2.5  ← error: Int and Double cannot be mixed
        log("Int(3.99) = \(Int(3.99)), rounded = \(Int(3.99.rounded()))")
    }

    static func overflow(_ log: SampleLog) {
        let largest = Int8.max
        log("Int8.max = \(largest)")
        log("Int8.max &+ 1 = \(largest &+ 1)")
        // largest + 1  ← stops the app: arithmetic overflow
        let (sum, overflow) = largest.addingReportingOverflow(1)
        log("addingReportingOverflow: \(sum), overflow: \(overflow)")
    }

    static func tuples(_ log: SampleLog) {
        let response = (code: 404, message: "Not Found")
        log("code: \(response.code), message: \(response.message)")
        let (code, message) = response
        log("destructured: \(code) \(message)")
        func minMax(_ values: [Int]) -> (min: Int, max: Int) {
            (values.min() ?? 0, values.max() ?? 0)
        }
        let range = minMax([7, 2, 9, 4])
        log("min \(range.min), max \(range.max)")
    }
}
