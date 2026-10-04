import Foundation

/// Samples for the Structs, classes & enums topic. Each function body is the code shown in its `CodeSample`.
enum TypeSemanticsSamples {
    static let all: [CodeSample] = [
        CodeSample(
            "Value and reference types",
            explanation: "The same steps on a struct and a class: copying a struct copies the value, copying a class shares one instance.",
            code: #"""
            struct PointValue { var x = 0 }
            final class PointObject { var x = 0 }

            let value = PointValue()
            var valueCopy = value
            valueCopy.x = 99
            log("struct: original \(value.x), copy \(valueCopy.x)")

            let object = PointObject()
            let objectCopy = object
            objectCopy.x = 99
            log("class: original \(object.x), copy \(objectCopy.x)")
            log("same instance: \(object === objectCopy)")
            """#,
            run: { valueAndReference($0) }
        ),
        CodeSample(
            "mutating methods",
            explanation: "A struct method that changes the struct is marked mutating, and can only be called on a var.",
            code: #"""
            struct Counter {
                var value = 0
                mutating func increment() { value += 1 }
            }
            var counter = Counter()
            counter.increment()
            counter.increment()
            log("var counter: \(counter.value)")
            let fixed = Counter()
            // fixed.increment()  ← error: cannot use mutating member on immutable value
            log("let counter: \(fixed.value)")
            """#,
            run: { mutatingMethods($0) }
        ),
        CodeSample(
            "Enums with raw values",
            explanation: "Raw values connect each case to a number or string; init?(rawValue:) returns nil for unknown values.",
            code: #"""
            enum Planet: Int, CaseIterable {
                case mercury = 1, venus, earth, mars
            }
            log("earth raw value: \(Planet.earth.rawValue)")
            log("Planet(rawValue: 4) = \(String(describing: Planet(rawValue: 4)))")
            log("Planet(rawValue: 9) = \(String(describing: Planet(rawValue: 9)))")
            log("all: \(Planet.allCases.map { "\($0)" }.joined(separator: ", "))")
            """#,
            run: { rawValues($0) }
        ),
        CodeSample(
            "Associated values",
            explanation: "Each case can carry its own data. switch must handle every case, and where adds a condition.",
            code: #"""
            enum Payment {
                case cash
                case card(last4: String)
                case transfer(bank: String, amount: Double)
            }
            let payments: [Payment] = [
                .cash, .card(last4: "4242"),
                .transfer(bank: "DBS", amount: 2500), .transfer(bank: "OCBC", amount: 80),
            ]
            for payment in payments {
                switch payment {
                case .cash:
                    log("cash")
                case .card(let last4):
                    log("card ending \(last4)")
                case .transfer(let bank, let amount) where amount >= 1000:
                    log("large transfer from \(bank): \(amount)")
                case .transfer(let bank, _):
                    log("transfer from \(bank)")
                }
            }
            """#,
            run: { associatedValues($0) }
        ),
        CodeSample(
            "Pattern matching",
            explanation: "switch can match tuples, ignore parts with _, bind values with let, and check ranges.",
            code: #"""
            let points = [(0, 0), (3, 0), (2, 2), (5, -1), (8, 4)]
            for point in points {
                switch point {
                case (0, 0): log("\(point): origin")
                case (_, 0): log("\(point): on the x-axis")
                case let (x, y) where x == y: log("\(point): on the diagonal")
                case (1...5, _): log("\(point): x between 1 and 5")
                default: log("\(point): somewhere else")
                }
            }
            """#,
            run: { patternMatching($0) }
        ),
    ]

    static func valueAndReference(_ log: SampleLog) {
        struct PointValue { var x = 0 }
        final class PointObject { var x = 0 }

        let value = PointValue()
        var valueCopy = value
        valueCopy.x = 99
        log("struct: original \(value.x), copy \(valueCopy.x)")

        let object = PointObject()
        let objectCopy = object
        objectCopy.x = 99
        log("class: original \(object.x), copy \(objectCopy.x)")
        log("same instance: \(object === objectCopy)")
    }

    static func mutatingMethods(_ log: SampleLog) {
        struct Counter {
            var value = 0
            mutating func increment() { value += 1 }
        }
        var counter = Counter()
        counter.increment()
        counter.increment()
        log("var counter: \(counter.value)")
        let fixed = Counter()
        // fixed.increment()  ← error: cannot use mutating member on immutable value
        log("let counter: \(fixed.value)")
    }

    static func rawValues(_ log: SampleLog) {
        enum Planet: Int, CaseIterable {
            case mercury = 1, venus, earth, mars
        }
        log("earth raw value: \(Planet.earth.rawValue)")
        log("Planet(rawValue: 4) = \(String(describing: Planet(rawValue: 4)))")
        log("Planet(rawValue: 9) = \(String(describing: Planet(rawValue: 9)))")
        log("all: \(Planet.allCases.map { "\($0)" }.joined(separator: ", "))")
    }

    static func associatedValues(_ log: SampleLog) {
        enum Payment {
            case cash
            case card(last4: String)
            case transfer(bank: String, amount: Double)
        }
        let payments: [Payment] = [
            .cash, .card(last4: "4242"),
            .transfer(bank: "DBS", amount: 2500), .transfer(bank: "OCBC", amount: 80),
        ]
        for payment in payments {
            switch payment {
            case .cash:
                log("cash")
            case .card(let last4):
                log("card ending \(last4)")
            case .transfer(let bank, let amount) where amount >= 1000:
                log("large transfer from \(bank): \(amount)")
            case .transfer(let bank, _):
                log("transfer from \(bank)")
            }
        }
    }

    static func patternMatching(_ log: SampleLog) {
        let points = [(0, 0), (3, 0), (2, 2), (5, -1), (8, 4)]
        for point in points {
            switch point {
            case (0, 0): log("\(point): origin")
            case (_, 0): log("\(point): on the x-axis")
            case let (x, y) where x == y: log("\(point): on the diagonal")
            case (1...5, _): log("\(point): x between 1 and 5")
            default: log("\(point): somewhere else")
            }
        }
    }
}
