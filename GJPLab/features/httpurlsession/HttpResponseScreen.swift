import SwiftUI

struct HttpResponseScreen: View {
    let response: HttpResponse
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 14) { Text("HttpURLConnection response details").foregroundStyle(.secondary); ResponseBlock(title: "HTTP status", value: "\(response.statusCode)", monospace: false); ResponseBlock(title: "Response JSON", value: response.body.isEmpty ? "(empty response)" : response.body); if !response.headers.isEmpty { ResponseBlock(title: "Headers", value: response.headers.map { "\($0.0): \($0.1)" }.joined(separator: "\n")) } }.padding(20) }.navigationTitle("Response") }
}

private struct ResponseBlock: View { let title: String; let value: String; var monospace = true; var body: some View { VStack(alignment: .leading, spacing: 10) { Text(title).font(.headline); Text(value).font(monospace ? .system(.body, design: .monospaced) : .body).textSelection(.enabled) }.frame(maxWidth: .infinity, alignment: .leading).padding(18).background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18)) } }
