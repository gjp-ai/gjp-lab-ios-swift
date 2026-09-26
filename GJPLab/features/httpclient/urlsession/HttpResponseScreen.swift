import SwiftUI

struct HttpResponseScreen: View {
    let response: HttpResponse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("URLSession response details")
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                ResponseBlock(
                    title: "HTTP status",
                    value: "\(response.statusCode)",
                    monospace: false,
                    valueColor: statusColor
                )
                ResponseBlock(title: "Response JSON", value: response.body.isEmpty ? "(empty response)" : response.body)
                if !response.headers.isEmpty {
                    ResponseBlock(title: "Headers", value: response.headers.map { "\($0.0): \($0.1)" }.joined(separator: "\n"))
                }
            }
            .frame(maxWidth: 720)
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Response")
        .labScreenBackground()
    }

    private var statusColor: Color {
        switch response.statusCode {
        case 200...299: LabTheme.success
        case 400...599: LabTheme.error
        default: LabTheme.onSurface
        }
    }
}

private struct ResponseBlock: View {
    let title: String
    let value: String
    var monospace = true
    var valueColor = LabTheme.onSurface

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline)
            ScrollView(.horizontal) {
                Text(value)
                    .font(monospace ? .system(.body, design: .monospaced) : .body)
                    .foregroundStyle(valueColor)
                    .textSelection(.enabled)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .labCard(cornerRadius: 18)
    }
}
