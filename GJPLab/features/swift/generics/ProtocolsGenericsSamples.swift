import Foundation

/// Samples for the Protocols & generics topic. Swift does not allow protocols inside functions, so the types
/// each sample declares live at file level below; the snippet shows them above the code that uses them.
enum ProtocolsGenericsSamples {
    static let all: [CodeSample] = [
        CodeSample(
            "Protocols",
            explanation: "A protocol lists requirements. Different types conform to it, and an any array can hold all of them.",
            code: #"""
            protocol Shape2D {
                var name: String { get }
                func area() -> Double
            }
            struct Square: Shape2D {
                let side: Double
                var name: String { "square" }
                func area() -> Double { side * side }
            }
            struct Disc: Shape2D {
                let radius: Double
                var name: String { "disc" }
                func area() -> Double { .pi * radius * radius }
            }

            let shapes: [any Shape2D] = [Square(side: 3), Disc(radius: 1)]
            for shape in shapes {
                log("\(shape.name): \(shape.area().formatted(.number.precision(.fractionLength(2))))")
            }
            """#,
            run: { protocols($0) }
        ),
        CodeSample(
            "Default implementations",
            explanation: "A protocol extension supplies a default; a conforming type can replace it with its own.",
            code: #"""
            protocol Describable {
                var name: String { get }
                func describe() -> String
            }
            extension Describable {
                func describe() -> String { "This is \(name)." }
            }
            struct Cat: Describable { let name = "a cat" }
            struct Robot: Describable {
                let name = "a robot"
                func describe() -> String { "BEEP. I AM \(name.uppercased())." }
            }

            log(Cat().describe())
            log(Robot().describe())
            """#,
            run: { defaultImplementations($0) }
        ),
        CodeSample(
            "Generic functions",
            explanation: "<T: Comparable> lets one function work with any type that can be compared.",
            code: #"""
            func largest<T: Comparable>(_ items: [T]) -> T? {
                guard var best = items.first else { return nil }
                for item in items.dropFirst() where item > best {
                    best = item
                }
                return best
            }
            log("Int: \(String(describing: largest([3, 9, 4])))")
            log("String: \(String(describing: largest(["pear", "apple", "zucchini"])))")
            log("empty: \(String(describing: largest([Double]())))")
            """#,
            run: { genericFunctions($0) }
        ),
        CodeSample(
            "Generic types",
            explanation: "Stack<Element> is written once and used with any element type.",
            code: #"""
            struct Stack<Element> {
                private var items: [Element] = []
                var isEmpty: Bool { items.isEmpty }
                mutating func push(_ item: Element) { items.append(item) }
                mutating func pop() -> Element? { items.popLast() }
            }

            var numbers = Stack<Int>()
            numbers.push(1)
            numbers.push(2)
            var words = Stack<String>()
            words.push("hello")
            log("Int pops: \(String(describing: numbers.pop())), \(String(describing: numbers.pop())), \(String(describing: numbers.pop()))")
            log("String pop: \(String(describing: words.pop())), now empty: \(words.isEmpty)")
            """#,
            run: { genericTypes($0) }
        ),
        CodeSample(
            "Associated types",
            explanation: "associatedtype leaves a type for each conforming type to choose, like Element in Array.",
            code: #"""
            protocol Container {
                associatedtype Item
                var items: [Item] { get }
            }
            extension Container {
                var count: Int { items.count }
            }
            struct Shelf: Container { let items = ["book", "lamp"] }
            struct Dice: Container { let items = [1, 2, 3, 4, 5, 6] }

            log("shelf: \(Shelf().count) items of \(type(of: Shelf().items))")
            log("dice: \(Dice().count) items of \(type(of: Dice().items))")
            """#,
            run: { associatedTypes($0) }
        ),
        CodeSample(
            "some versus any",
            explanation: "some returns one hidden concrete type that is fixed for the function; any can hold a different type each time.",
            code: #"""
            func makeShape(large: Bool) -> some Shape2D {
                Square(side: large ? 10 : 2)  // always a Square
            }
            func makeAnyShape(round: Bool) -> any Shape2D {
                if round {
                    return Disc(radius: 1)
                } else {
                    return Square(side: 1)
                }
            }
            log("some: \(type(of: makeShape(large: true)))")
            log("any: \(type(of: makeAnyShape(round: true))), \(type(of: makeAnyShape(round: false)))")
            """#,
            run: { someVersusAny($0) }
        ),
    ]

    static func protocols(_ log: SampleLog) {
        let shapes: [any Shape2D] = [Square(side: 3), Disc(radius: 1)]
        for shape in shapes {
            log("\(shape.name): \(shape.area().formatted(.number.precision(.fractionLength(2))))")
        }
    }

    static func defaultImplementations(_ log: SampleLog) {
        log(Cat().describe())
        log(Robot().describe())
    }

    static func genericFunctions(_ log: SampleLog) {
        func largest<T: Comparable>(_ items: [T]) -> T? {
            guard var best = items.first else { return nil }
            for item in items.dropFirst() where item > best {
                best = item
            }
            return best
        }
        log("Int: \(String(describing: largest([3, 9, 4])))")
        log("String: \(String(describing: largest(["pear", "apple", "zucchini"])))")
        log("empty: \(String(describing: largest([Double]())))")
    }

    static func genericTypes(_ log: SampleLog) {
        var numbers = Stack<Int>()
        numbers.push(1)
        numbers.push(2)
        var words = Stack<String>()
        words.push("hello")
        log("Int pops: \(String(describing: numbers.pop())), \(String(describing: numbers.pop())), \(String(describing: numbers.pop()))")
        log("String pop: \(String(describing: words.pop())), now empty: \(words.isEmpty)")
    }

    static func associatedTypes(_ log: SampleLog) {
        log("shelf: \(Shelf().count) items of \(type(of: Shelf().items))")
        log("dice: \(Dice().count) items of \(type(of: Dice().items))")
    }

    static func someVersusAny(_ log: SampleLog) {
        log("some: \(type(of: makeShape(large: true)))")
        log("any: \(type(of: makeAnyShape(round: true))), \(type(of: makeAnyShape(round: false)))")
    }
}

// MARK: - Types used by the samples (fileprivate so they do not clash with SwiftUI or other features)

fileprivate protocol Shape2D {
    var name: String { get }
    func area() -> Double
}

fileprivate struct Square: Shape2D {
    let side: Double
    var name: String { "square" }
    func area() -> Double { side * side }
}

fileprivate struct Disc: Shape2D {
    let radius: Double
    var name: String { "disc" }
    func area() -> Double { .pi * radius * radius }
}

fileprivate protocol Describable {
    var name: String { get }
    func describe() -> String
}

fileprivate extension Describable {
    func describe() -> String { "This is \(name)." }
}

fileprivate struct Cat: Describable { let name = "a cat" }

fileprivate struct Robot: Describable {
    let name = "a robot"
    func describe() -> String { "BEEP. I AM \(name.uppercased())." }
}

fileprivate struct Stack<Element> {
    private var items: [Element] = []
    var isEmpty: Bool { items.isEmpty }
    mutating func push(_ item: Element) { items.append(item) }
    mutating func pop() -> Element? { items.popLast() }
}

fileprivate protocol Container {
    associatedtype Item
    var items: [Item] { get }
}

fileprivate extension Container {
    var count: Int { items.count }
}

fileprivate struct Shelf: Container { let items = ["book", "lamp"] }

fileprivate struct Dice: Container { let items = [1, 2, 3, 4, 5, 6] }

fileprivate func makeShape(large: Bool) -> some Shape2D {
    Square(side: large ? 10 : 2)  // always a Square
}

fileprivate func makeAnyShape(round: Bool) -> any Shape2D {
    if round {
        return Disc(radius: 1)
    } else {
        return Square(side: 1)
    }
}
