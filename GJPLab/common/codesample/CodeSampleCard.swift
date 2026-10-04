import SwiftUI

/// A scrolling page of runnable samples for one Swift topic.
struct CodeSamplePage: View {
    let title: String
    let intro: String
    let samples: [CodeSample]

    var body: some View {
        LabDemoPage(title: title, intro: intro + " Samples call log(_:) where a playground would call print(_:).") {
            ForEach(samples) { sample in
                CodeSampleCard(sample: sample)
            }
        }
    }
}

/// One sample: explanation, code, a Run button, and the output of the last run.
struct CodeSampleCard: View {
    let sample: CodeSample
    @State private var output: [String]?
    @State private var runCount = 0
    @State private var isRunning = false

    var body: some View {
        LabDemoSection(title: sample.title, caption: sample.explanation) {
            ScrollView(.horizontal) {
                // Code keeps its line breaks and scrolls sideways instead of wrapping.
                Text(sample.code)
                    .font(.footnote.monospaced())
                    .textSelection(.enabled)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(12)
            }
            .background(LabTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            Button {
                runCount += 1
            } label: {
                HStack(spacing: 8) {
                    if isRunning {
                        ProgressView().tint(LabTheme.onSurfaceVariant)
                    }
                    Text(isRunning ? "Running…" : "Run")
                }
            }
            .buttonStyle(.labPrimary)
            .disabled(isRunning)
            .accessibilityIdentifier("codeSample.run")

            VStack(alignment: .leading, spacing: 6) {
                Text("Output")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                if let output {
                    Text(output.joined(separator: "\n"))
                        .font(.footnote.monospaced())
                        .textSelection(.enabled)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("codeSample.output")
                } else {
                    Text("Tap Run to see the output")
                        .font(.footnote)
                        .foregroundStyle(LabTheme.onSurfaceVariant)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(LabTheme.outlineVariant, lineWidth: 0.5)
            }
        }
        // Tied to the view's lifetime: leaving the topic cancels a running sample.
        .task(id: runCount) {
            guard runCount > 0 else { return }
            isRunning = true
            let lines = await sample.output()
            guard !Task.isCancelled else { return }
            output = lines
            isRunning = false
            AccessibilityNotification.Announcement("Output: " + lines.joined(separator: ". ")).post()
        }
    }
}

private let previewSample = CodeSample(
    "Hello",
    explanation: "A sample logs lines instead of printing them.",
    code: #"""
    let name = "Swift"
    log("Hello, \(name)!")
    """#,
    run: { log in
        let name = "Swift"
        log("Hello, \(name)!")
    }
)

#Preview("Code sample – light") {
    NavigationStack { CodeSamplePage(title: "Preview", intro: "A runnable sample.", samples: [previewSample]) }
}

#Preview("Code sample – dark") {
    NavigationStack { CodeSamplePage(title: "Preview", intro: "A runnable sample.", samples: [previewSample]) }
        .preferredColorScheme(.dark)
}
