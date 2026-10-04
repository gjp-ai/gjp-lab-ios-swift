import Foundation

/// Samples for the Concurrency topic. Helpers that child tasks call live at file level as `@concurrent` or
/// `nonisolated` functions, so they are not tied to the main actor. Output never depends on timing or on
/// which task finishes first; parallel results are sorted before they are logged.
enum ConcurrencySamples {
    static let all: [CodeSample] = [
        CodeSample(
            "async and await",
            explanation: "await marks a point where the function can pause without blocking; other work, such as the UI, keeps running.",
            code: #"""
            @concurrent
            func fetchGreeting(for name: String) async -> String {
                try? await Task.sleep(for: .milliseconds(300))  // stands in for a network call
                return "Hello, \(name)"
            }

            log("before await")
            let greeting = await fetchGreeting(for: "Ada")
            log(greeting)
            log("after await")
            """#,
            run: { await asyncAwait($0) }
        ),
        CodeSample(
            "async let",
            explanation: "async let starts several calls at once and waits for them together, instead of one after another.",
            code: #"""
            @concurrent
            func price(of item: String) async -> Int {
                try? await Task.sleep(for: .milliseconds(400))
                return item.count * 10
            }

            async let apple = price(of: "apple")
            async let melon = price(of: "melon")
            async let kiwi = price(of: "kiwi")
            let total = await apple + melon + kiwi
            log("total: \(total)")
            log("three 0.4-second waits ran at the same time")
            """#,
            run: { await asyncLet($0) }
        ),
        CodeSample(
            "Task groups",
            explanation: "A task group runs a child task per item. Children finish in any order, so the results are sorted.",
            code: #"""
            let words = ["swift", "actor", "task", "await"]
            let lengths = await withTaskGroup(of: (String, Int).self) { group in
                for word in words {
                    group.addTask { (word, word.count) }
                }
                var results: [(String, Int)] = []
                for await result in group {
                    results.append(result)
                }
                return results
            }
            for (word, length) in lengths.sorted(by: { $0.0 < $1.0 }) {
                log("\(word): \(length)")
            }
            """#,
            run: { await taskGroups($0) }
        ),
        CodeSample(
            "Cancellation",
            explanation: "Cancelling a task only sets a flag. The task checks Task.isCancelled and stops itself.",
            code: #"""
            @concurrent
            func countSlowly(to limit: Int) async -> Int {
                var count = 0
                for _ in 1...limit {
                    if Task.isCancelled { break }
                    try? await Task.sleep(for: .milliseconds(100))
                    count += 1
                }
                return count
            }

            let reached = await withTaskGroup(of: Int.self) { group in
                group.addTask { await countSlowly(to: 50) }
                try? await Task.sleep(for: .milliseconds(450))
                group.cancelAll()
                return await group.next() ?? 0
            }
            log("asked to count to 50")
            log("stopped early: \(reached < 50)")
            """#,
            run: { await cancellation($0) }
        ),
        CodeSample(
            "Actors",
            explanation: "An actor lets one task at a time change its state, so 1,000 tasks selling tickets never lose a sale.",
            code: #"""
            actor TicketCounter {
                private(set) var sold = 0
                func sell() { sold += 1 }
            }

            let counter = TicketCounter()
            await withTaskGroup(of: Void.self) { group in
                for _ in 1...1000 {
                    group.addTask { await counter.sell() }
                }
            }
            let sold = await counter.sold
            log("tickets sold: \(sold)")
            """#,
            run: { await actors($0) }
        ),
        CodeSample(
            "Main actor and @concurrent",
            explanation: "This app runs code on the main actor by default. @concurrent moves heavy work to background threads so the UI stays responsive.",
            code: #"""
            nonisolated func isOnMainThread() -> Bool { Thread.isMainThread }

            @concurrent
            func sumOfSquares(upTo limit: Int) async -> (sum: Int, onMainThread: Bool) {
                let sum = (1...limit).reduce(0) { $0 + $1 * $1 }
                return (sum, isOnMainThread())
            }

            log("sample starts on the main thread: \(isOnMainThread())")
            let result = await sumOfSquares(upTo: 1000)
            log("sum of squares to 1000: \(result.sum)")
            log("worked on the main thread: \(result.onMainThread)")
            """#,
            run: { await mainActorAndConcurrent($0) }
        ),
    ]

    static func asyncAwait(_ log: SampleLog) async {
        log("before await")
        let greeting = await fetchGreeting(for: "Ada")
        log(greeting)
        log("after await")
    }

    static func asyncLet(_ log: SampleLog) async {
        async let apple = price(of: "apple")
        async let melon = price(of: "melon")
        async let kiwi = price(of: "kiwi")
        let total = await apple + melon + kiwi
        log("total: \(total)")
        log("three 0.4-second waits ran at the same time")
    }

    static func taskGroups(_ log: SampleLog) async {
        let words = ["swift", "actor", "task", "await"]
        let lengths = await withTaskGroup(of: (String, Int).self) { group in
            for word in words {
                group.addTask { (word, word.count) }
            }
            var results: [(String, Int)] = []
            for await result in group {
                results.append(result)
            }
            return results
        }
        for (word, length) in lengths.sorted(by: { $0.0 < $1.0 }) {
            log("\(word): \(length)")
        }
    }

    static func cancellation(_ log: SampleLog) async {
        let reached = await withTaskGroup(of: Int.self) { group in
            group.addTask { await countSlowly(to: 50) }
            try? await Task.sleep(for: .milliseconds(450))
            group.cancelAll()
            return await group.next() ?? 0
        }
        log("asked to count to 50")
        log("stopped early: \(reached < 50)")
    }

    static func actors(_ log: SampleLog) async {
        let counter = TicketCounter()
        await withTaskGroup(of: Void.self) { group in
            for _ in 1...1000 {
                group.addTask { await counter.sell() }
            }
        }
        let sold = await counter.sold
        log("tickets sold: \(sold)")
    }

    static func mainActorAndConcurrent(_ log: SampleLog) async {
        log("sample starts on the main thread: \(isOnMainThread())")
        let result = await sumOfSquares(upTo: 1000)
        log("sum of squares to 1000: \(result.sum)")
        log("worked on the main thread: \(result.onMainThread)")
    }
}

// MARK: - Helpers called by the samples

@concurrent
fileprivate func fetchGreeting(for name: String) async -> String {
    try? await Task.sleep(for: .milliseconds(300))  // stands in for a network call
    return "Hello, \(name)"
}

@concurrent
fileprivate func price(of item: String) async -> Int {
    try? await Task.sleep(for: .milliseconds(400))
    return item.count * 10
}

@concurrent
fileprivate func countSlowly(to limit: Int) async -> Int {
    var count = 0
    for _ in 1...limit {
        if Task.isCancelled { break }
        try? await Task.sleep(for: .milliseconds(100))
        count += 1
    }
    return count
}

fileprivate actor TicketCounter {
    private(set) var sold = 0
    func sell() { sold += 1 }
}

nonisolated fileprivate func isOnMainThread() -> Bool { Thread.isMainThread }

@concurrent
fileprivate func sumOfSquares(upTo limit: Int) async -> (sum: Int, onMainThread: Bool) {
    let sum = (1...limit).reduce(0) { $0 + $1 * $1 }
    return (sum, isOnMainThread())
}
