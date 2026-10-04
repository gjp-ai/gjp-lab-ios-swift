import Foundation

/// Samples for the Strings & regex topic. Each function body is the code shown in its `CodeSample`.
enum StringsRegexSamples {
    static let all: [CodeSample] = [
        CodeSample(
            "Characters and Unicode",
            explanation: "count counts what a reader sees as characters. One character can be several Unicode scalars and many UTF-8 bytes.",
            code: #"""
            let cafe = "cafe\u{301}"  // e + combining acute accent
            let flag = "🇸🇬"
            let family = "👨‍👩‍👧"
            for text in [cafe, flag, family] {
                log("\(text): \(text.count) characters, \(text.unicodeScalars.count) scalars, \(text.utf8.count) UTF-8 bytes")
            }
            """#,
            run: { charactersAndUnicode($0) }
        ),
        CodeSample(
            "String indices",
            explanation: "Characters have different sizes, so strings use String.Index instead of Int positions.",
            code: #"""
            let greeting = "Hello, Swift"
            // greeting[7]  ← error: String cannot be subscripted with an Int
            let start = greeting.index(greeting.startIndex, offsetBy: 7)
            log("from offset 7: \(greeting[start...])")
            log("prefix(5): \(greeting.prefix(5))")
            if let comma = greeting.firstIndex(of: ",") {
                log("before the comma: \(greeting[..<comma])")
            }
            log("reversed: \(String(greeting.reversed()))")
            """#,
            run: { stringIndices($0) }
        ),
        CodeSample(
            "Interpolation, multiline, and raw strings",
            explanation: "\\( ) inserts values. Triple quotes span lines. A raw string #\"…\"# keeps backslashes, and \\#( ) still interpolates.",
            code: ##"""
            let name = "Ada"
            let year = 1843
            log("\(name) published her notes in \(year).")
            let poem = """
                Roses are red,
                Swift is fast.
                """
            log("multiline string has \(poem.split(separator: "\n").count) lines")
            let path = #"C:\Users\Ada"#
            log("raw: \(path)")
            log(#"raw with interpolation: Hi \#(name)"#)
            """##,
            run: { interpolationAndRawStrings($0) }
        ),
        CodeSample(
            "Regex matching",
            explanation: "A regex literal between slashes is checked by the compiler; its captures become typed tuple elements.",
            code: #"""
            let text = "Releases: Swift 5.9 in 2023, Swift 6.0 in 2024."
            if let match = text.firstMatch(of: /Swift (\d+)\.(\d+)/) {
                log("first: \(match.0), major \(match.1), minor \(match.2)")
            }
            let years = text.matches(of: /\d{4}/).map { String($0.output) }
            log("years: \(years.joined(separator: ", "))")
            log("replaced: \(text.replacing(/\d{4}/, with: "----"))")
            """#,
            run: { regexMatching($0) }
        ),
        CodeSample(
            "Named captures",
            explanation: "(?<name>…) names a capture, so the match is read as match.name instead of a tuple position.",
            code: #"""
            let line = "2026-10-04 ERROR Disk full"
            let entry = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2}) (?<level>[A-Z]+) (?<message>.+)/
            if let match = line.wholeMatch(of: entry) {
                log("year: \(match.year)")
                log("month: \(match.month), day: \(match.day)")
                log("level: \(match.level)")
                log("message: \(match.message)")
            }
            """#,
            run: { namedCaptures($0) }
        ),
        CodeSample(
            "Comparing strings",
            explanation: "== compares what the text means, so two Unicode spellings of café are equal even though their bytes differ.",
            code: #"""
            let precomposed = "caf\u{E9}"  // é as one scalar
            let decomposed = "cafe\u{301}"  // e + combining accent
            log("== : \(precomposed == decomposed)")
            log("same UTF-8 bytes: \(Array(precomposed.utf8) == Array(decomposed.utf8))")
            log("\"Le Café\" contains \"CAFE\": \("Le Café".localizedStandardContains("CAFE"))")
            """#,
            run: { comparingStrings($0) }
        ),
    ]

    static func charactersAndUnicode(_ log: SampleLog) {
        let cafe = "cafe\u{301}"  // e + combining acute accent
        let flag = "🇸🇬"
        let family = "👨‍👩‍👧"
        for text in [cafe, flag, family] {
            log("\(text): \(text.count) characters, \(text.unicodeScalars.count) scalars, \(text.utf8.count) UTF-8 bytes")
        }
    }

    static func stringIndices(_ log: SampleLog) {
        let greeting = "Hello, Swift"
        // greeting[7]  ← error: String cannot be subscripted with an Int
        let start = greeting.index(greeting.startIndex, offsetBy: 7)
        log("from offset 7: \(greeting[start...])")
        log("prefix(5): \(greeting.prefix(5))")
        if let comma = greeting.firstIndex(of: ",") {
            log("before the comma: \(greeting[..<comma])")
        }
        log("reversed: \(String(greeting.reversed()))")
    }

    static func interpolationAndRawStrings(_ log: SampleLog) {
        let name = "Ada"
        let year = 1843
        log("\(name) published her notes in \(year).")
        let poem = """
            Roses are red,
            Swift is fast.
            """
        log("multiline string has \(poem.split(separator: "\n").count) lines")
        let path = #"C:\Users\Ada"#
        log("raw: \(path)")
        log(#"raw with interpolation: Hi \#(name)"#)
    }

    static func regexMatching(_ log: SampleLog) {
        let text = "Releases: Swift 5.9 in 2023, Swift 6.0 in 2024."
        if let match = text.firstMatch(of: /Swift (\d+)\.(\d+)/) {
            log("first: \(match.0), major \(match.1), minor \(match.2)")
        }
        let years = text.matches(of: /\d{4}/).map { String($0.output) }
        log("years: \(years.joined(separator: ", "))")
        log("replaced: \(text.replacing(/\d{4}/, with: "----"))")
    }

    static func namedCaptures(_ log: SampleLog) {
        let line = "2026-10-04 ERROR Disk full"
        let entry = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2}) (?<level>[A-Z]+) (?<message>.+)/
        if let match = line.wholeMatch(of: entry) {
            log("year: \(match.year)")
            log("month: \(match.month), day: \(match.day)")
            log("level: \(match.level)")
            log("message: \(match.message)")
        }
    }

    static func comparingStrings(_ log: SampleLog) {
        let precomposed = "caf\u{E9}"  // é as one scalar
        let decomposed = "cafe\u{301}"  // e + combining accent
        log("== : \(precomposed == decomposed)")
        log("same UTF-8 bytes: \(Array(precomposed.utf8) == Array(decomposed.utf8))")
        log("\"Le Café\" contains \"CAFE\": \("Le Café".localizedStandardContains("CAFE"))")
    }
}
