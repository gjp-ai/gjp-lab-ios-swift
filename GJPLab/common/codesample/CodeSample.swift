import Foundation

/// One runnable Swift sample: the code shown on screen and the function that runs it.
/// `run` is the code itself, so the output is real, not hard-coded text.
struct CodeSample: Identifiable {
    let title: String
    let explanation: String
    /// The code as shown to the reader. Keep it identical to the body of `run`.
    let code: String
    let run: @MainActor (SampleLog) async -> Void

    var id: String { title }

    /// `run` may be synchronous or `async`; a synchronous function converts to the async type automatically.
    init(_ title: String, explanation: String, code: String, run: @escaping @MainActor (SampleLog) async -> Void) {
        self.title = title
        self.explanation = explanation
        self.code = code
        self.run = run
    }

    /// Runs the sample and returns the lines it logged.
    func output() async -> [String] {
        let log = SampleLog()
        await run(log)
        return log.lines
    }
}

/// Collects the lines a sample prints. Samples write `log("…")` where a playground would write `print("…")`.
/// It is `nonisolated` so `deinit` in the Memory samples, which is not on the main actor, can log too.
nonisolated final class SampleLog {
    private(set) var lines: [String] = []

    func callAsFunction(_ line: String) {
        lines.append(line)
    }
}
