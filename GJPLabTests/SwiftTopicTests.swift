import Testing
@testable import GJPLab

/// Runs the Swift category's samples and checks what they log. Every sample is run by the generic tests;
/// the topic tests check the lines that show each language feature.
@MainActor
struct SwiftTopicTests {

    private static let topics: [(name: String, samples: [CodeSample])] = [
        ("Values & types", BasicsSamples.all),
        ("Optionals", OptionalsSamples.all),
        ("Collections", CollectionsSamples.all),
        ("Functions & closures", ClosuresSamples.all),
        ("Structs, classes & enums", TypeSemanticsSamples.all),
        ("Protocols & generics", ProtocolsGenericsSamples.all),
        ("Error handling", ErrorHandlingSamples.all),
        ("Concurrency", ConcurrencySamples.all),
        ("Memory management", MemorySamples.all),
        ("Strings & regex", StringsRegexSamples.all),
    ]

    private func output(_ samples: [CodeSample], _ title: String) async throws -> [String] {
        let sample = try #require(samples.first { $0.title == title }, "No sample titled \(title)")
        return await sample.output()
    }

    // MARK: Every sample

    @Test func everyTopicHasUniquelyTitledSamples() {
        for topic in Self.topics {
            #expect(!topic.samples.isEmpty, "\(topic.name) has no samples")
            #expect(Set(topic.samples.map(\.id)).count == topic.samples.count, "\(topic.name) repeats a title")
        }
    }

    @Test func everySampleLogsOutputAndShowsItsCode() async {
        for topic in Self.topics {
            for sample in topic.samples {
                #expect(!sample.code.isEmpty, "\(topic.name) – \(sample.title) shows no code")
                let lines = await sample.output()
                #expect(!lines.isEmpty, "\(topic.name) – \(sample.title) logged nothing")
            }
        }
    }

    @Test func everySampleLogsTheSameOutputEachRun() async {
        for topic in Self.topics {
            for sample in topic.samples {
                let first = await sample.output()
                let second = await sample.output()
                #expect(first == second, "\(topic.name) – \(sample.title) changed between runs")
            }
        }
    }

    // MARK: Topics

    @Test func basicsShowsInferredTypesAndWrappingOverflow() async throws {
        let types = try await output(BasicsSamples.all, "Type inference")
        #expect(types.contains("42: Int"))
        #expect(types.contains("3.5: Double"))
        #expect(types.contains("42.0: Double"))

        let overflow = try await output(BasicsSamples.all, "Overflow")
        #expect(overflow.contains("Int8.max &+ 1 = -128"))
        #expect(overflow.contains("addingReportingOverflow: -128, overflow: true"))
    }

    @Test func optionalsHandleBothValueAndNil() async throws {
        let guardLet = try await output(OptionalsSamples.all, "guard let")
        #expect(guardLet == ["Next year you will be 37", "\"abc\" is not a number"])

        let forceUnwrap = try await output(OptionalsSamples.all, "Force unwrapping")
        #expect(forceUnwrap.first == "stock[\"pear\"] ?? 0 = 0")
    }

    @Test func collectionsSortUnorderedResults() async throws {
        let sets = try await output(CollectionsSamples.all, "Sets")
        #expect(sets.first == #"both: ["C"]"#)

        let arrays = try await output(CollectionsSamples.all, "Arrays")
        #expect(arrays.first == #"array: ["C", "Kotlin", "Rust"]"#)

        let copies = try await output(CollectionsSamples.all, "Copies are independent")
        #expect(copies == ["original: [1, 2, 3]", "copy: [1, 2, 3, 4]"])
    }

    @Test func closuresKeepTheirOwnCapturedState() async throws {
        let counters = try await output(ClosuresSamples.all, "Capturing values")
        #expect(counters == ["first: 1, 2, 3", "second: 1, 2"])
    }

    @Test func structsCopyAndClassesShare() async throws {
        let lines = try await output(TypeSemanticsSamples.all, "Value and reference types")
        #expect(lines == ["struct: original 0, copy 99", "class: original 99, copy 99", "same instance: true"])
    }

    @Test func someIsOneTypeAndAnyCanVary() async throws {
        let lines = try await output(ProtocolsGenericsSamples.all, "some versus any")
        #expect(lines == ["some: Square", "any: Disc, Square"])
    }

    @Test func deferRunsOnSuccessAndFailure() async throws {
        let lines = try await output(ErrorHandlingSamples.all, "defer")
        #expect(lines == [
            "open \"Ada\"", "processed ada", "close \"Ada\"", "result: ok",
            "open \"\"", "failed: empty", "close \"\"", "result: error",
        ])
    }

    @Test func concurrencyResultsDoNotDependOnTiming() async throws {
        let lengths = try await output(ConcurrencySamples.all, "Task groups")
        #expect(lengths == ["actor: 5", "await: 5", "swift: 5", "task: 4"])

        let tickets = try await output(ConcurrencySamples.all, "Actors")
        #expect(tickets == ["tickets sold: 1000"])

        let cancelled = try await output(ConcurrencySamples.all, "Cancellation")
        #expect(cancelled.contains("stopped early: true"))

        let threads = try await output(ConcurrencySamples.all, "Main actor and @concurrent")
        #expect(threads == [
            "sample starts on the main thread: true",
            "sum of squares to 1000: 333833500",
            "worked on the main thread: false",
        ])
    }

    @Test func retainCyclesKeepObjectsAliveAndWeakFreesThem() async throws {
        let lifetime = try await output(MemorySamples.all, "Object lifetime")
        let freed = try #require(lifetime.firstIndex(of: "deinit Ada"))
        let ended = try #require(lifetime.firstIndex(of: "scope ended"))
        #expect(freed < ended)

        let cycles = try await output(MemorySamples.all, "Retain cycles and weak")
        #expect(!cycles.contains("deinit owner Sam"))
        #expect(cycles.contains("deinit owner Kim"))
        #expect(cycles.contains("deinit pet Tom"))

        let closures = try await output(MemorySamples.all, "Capturing self in closures")
        #expect(!closures.contains("deinit strong capture"))
        #expect(closures.contains("deinit weak capture"))

        let unowned = try await output(MemorySamples.all, "unowned")
        #expect(unowned.contains("deinit customer Lee"))
        #expect(unowned.contains("deinit card 1234"))
    }

    @Test func stringsCountCharactersNotBytes() async throws {
        let counts = try await output(StringsRegexSamples.all, "Characters and Unicode")
        #expect(counts.count == 3)
        #expect(counts[0].hasSuffix("4 characters, 5 scalars, 6 UTF-8 bytes"))
        #expect(counts[1].hasSuffix("1 characters, 2 scalars, 8 UTF-8 bytes"))
        #expect(counts[2].hasSuffix("1 characters, 5 scalars, 18 UTF-8 bytes"))

        let captures = try await output(StringsRegexSamples.all, "Named captures")
        #expect(captures.first == "year: 2026")

        let comparison = try await output(StringsRegexSamples.all, "Comparing strings")
        #expect(comparison.prefix(2) == ["== : true", "same UTF-8 bytes: false"])
    }
}
