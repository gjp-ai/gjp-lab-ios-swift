import Foundation

/// Samples for the Error handling topic. `ValidationError` and `validate(username:)` are shared by several
/// samples, so they live at file level and are shown in the snippets that first use them.
enum ErrorHandlingSamples {
    static let all: [CodeSample] = [
        CodeSample(
            "throws, do, and catch",
            explanation: "A throwing function reports failure with throw; the caller uses try inside do and handles errors in catch clauses.",
            code: #"""
            enum FileError: Error {
                case notFound(name: String)
                case noPermission
            }
            func open(_ name: String) throws -> String {
                switch name {
                case "notes.txt": return "Buy milk"
                case "secret.txt": throw FileError.noPermission
                default: throw FileError.notFound(name: name)
                }
            }
            for name in ["notes.txt", "secret.txt", "photo.png"] {
                do {
                    let text = try open(name)
                    log("\(name): \(text)")
                } catch FileError.notFound(let missing) {
                    log("\(missing): not found")
                } catch {
                    log("\(name): \(error)")
                }
            }
            """#,
            run: { doCatch($0) }
        ),
        CodeSample(
            "Typed throws",
            explanation: "throws(ValidationError) names the only error type, so catch receives a ValidationError instead of any Error.",
            code: #"""
            enum ValidationError: Error {
                case empty
                case tooShort(minimum: Int)
            }
            func validate(username: String) throws(ValidationError) -> String {
                if username.isEmpty { throw .empty }
                if username.count < 3 { throw .tooShort(minimum: 3) }
                return username.lowercased()
            }

            for name in ["Ada", "", "Al"] {
                do {
                    let valid = try validate(username: name)
                    log("valid: \(valid)")
                } catch {
                    switch error {  // error is a ValidationError here
                    case .empty: log("\"\(name)\": empty")
                    case .tooShort(let minimum): log("\"\(name)\": shorter than \(minimum)")
                    }
                }
            }
            """#,
            run: { typedThrows($0) }
        ),
        CodeSample(
            "try? and try!",
            explanation: "try? turns an error into nil. try! stops the app on an error, so this sample explains it instead of running it.",
            code: #"""
            let parsed = try? validate(username: "Grace")
            let failed = try? validate(username: "")
            log("try? success: \(String(describing: parsed))")
            log("try? failure: \(String(describing: failed))")
            // let crash = try! validate(username: "")  ← stops the app
            log("try! is only for calls that cannot fail")
            """#,
            run: { tryOptional($0) }
        ),
        CodeSample(
            "Result",
            explanation: "Result stores a success or a failure as a value, to pass around or handle later; get() turns it back into a throwing call.",
            code: #"""
            let results = ["Linus", "X"].map { name in
                Result { () throws(ValidationError) -> String in try validate(username: name) }
            }
            for result in results {
                switch result {
                case .success(let name): log("success: \(name)")
                case .failure(let error): log("failure: \(error)")
                }
            }
            log("successes: \(results.compactMap { try? $0.get() })")
            """#,
            run: { resultType($0) }
        ),
        CodeSample(
            "defer",
            explanation: "defer runs when the scope exits, on success and on failure, which makes it the place for cleanup.",
            code: #"""
            func process(_ input: String) -> String {
                log("open \"\(input)\"")
                defer { log("close \"\(input)\"") }
                do {
                    let name = try validate(username: input)
                    log("processed \(name)")
                    return "ok"
                } catch {
                    log("failed: \(error)")
                    return "error"
                }
            }
            log("result: \(process("Ada"))")
            log("result: \(process(""))")
            """#,
            run: { deferCleanup($0) }
        ),
    ]

    static func doCatch(_ log: SampleLog) {
        enum FileError: Error {
            case notFound(name: String)
            case noPermission
        }
        func open(_ name: String) throws -> String {
            switch name {
            case "notes.txt": return "Buy milk"
            case "secret.txt": throw FileError.noPermission
            default: throw FileError.notFound(name: name)
            }
        }
        for name in ["notes.txt", "secret.txt", "photo.png"] {
            do {
                let text = try open(name)
                log("\(name): \(text)")
            } catch FileError.notFound(let missing) {
                log("\(missing): not found")
            } catch {
                log("\(name): \(error)")
            }
        }
    }

    static func typedThrows(_ log: SampleLog) {
        for name in ["Ada", "", "Al"] {
            do {
                let valid = try validate(username: name)
                log("valid: \(valid)")
            } catch {
                switch error {  // error is a ValidationError here
                case .empty: log("\"\(name)\": empty")
                case .tooShort(let minimum): log("\"\(name)\": shorter than \(minimum)")
                }
            }
        }
    }

    static func tryOptional(_ log: SampleLog) {
        let parsed = try? validate(username: "Grace")
        let failed = try? validate(username: "")
        log("try? success: \(String(describing: parsed))")
        log("try? failure: \(String(describing: failed))")
        // let crash = try! validate(username: "")  ← stops the app
        log("try! is only for calls that cannot fail")
    }

    static func resultType(_ log: SampleLog) {
        let results = ["Linus", "X"].map { name in
            Result { () throws(ValidationError) -> String in try validate(username: name) }
        }
        for result in results {
            switch result {
            case .success(let name): log("success: \(name)")
            case .failure(let error): log("failure: \(error)")
            }
        }
        log("successes: \(results.compactMap { try? $0.get() })")
    }

    static func deferCleanup(_ log: SampleLog) {
        func process(_ input: String) -> String {
            log("open \"\(input)\"")
            defer { log("close \"\(input)\"") }
            do {
                let name = try validate(username: input)
                log("processed \(name)")
                return "ok"
            } catch {
                log("failed: \(error)")
                return "error"
            }
        }
        log("result: \(process("Ada"))")
        log("result: \(process(""))")
    }
}

// MARK: - Shared by the samples

fileprivate enum ValidationError: Error {
    case empty
    case tooShort(minimum: Int)
}

fileprivate func validate(username: String) throws(ValidationError) -> String {
    if username.isEmpty { throw .empty }
    if username.count < 3 { throw .tooShort(minimum: 3) }
    return username.lowercased()
}
