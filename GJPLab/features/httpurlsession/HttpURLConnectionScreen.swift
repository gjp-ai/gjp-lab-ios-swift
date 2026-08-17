import SwiftUI

struct HttpURLConnectionScreen: View {
    @State private var method = HttpMethod.GET
    @State private var url = "https://www.ganjianping.com/api/open/websites?channel=AI&page=0&size=500&lang=EN"
    @State private var payload = "{\n  \"example\": \"value\"\n}"
    @State private var errorMessage: String?; @State private var isLoading = false; @State private var response: HttpResponse?
    private let repository = HttpURLConnectionRepository()
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 16) { Text("Build and send an HTTP request with the native iOS API.").foregroundStyle(.secondary); Text("Method").font(.headline); Picker("Method", selection: $method) { ForEach(HttpMethod.allCases) { Text($0.rawValue).tag($0) } }.pickerStyle(.segmented); TextField("https://example.com/api", text: $url, axis: .vertical).textFieldStyle(.roundedBorder).textInputAutocapitalization(.never).autocorrectionDisabled(); if method.supportsPayload { TextField("JSON payload", text: $payload, axis: .vertical).textFieldStyle(.roundedBorder).lineLimit(6...12).font(.system(.body, design: .monospaced)) }; if let errorMessage { Text(errorMessage).foregroundStyle(.red) }; Button { Task { await send() } } label: { if isLoading { ProgressView().frame(maxWidth: .infinity) } else { Text("Send request").frame(maxWidth: .infinity) } }.buttonStyle(.borderedProminent).disabled(isLoading || url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty); if let response { NavigationLink(value: FeatureRoute.response(response)) { Label("View response (HTTP \(response.statusCode))", systemImage: "arrow.right.circle") } } }.padding(20) }.navigationTitle("HttpURLConnection") }
    private func send() async { isLoading = true; errorMessage = nil; defer { isLoading = false }; do { response = try await repository.execute(method: method, urlText: url, payload: payload) } catch { errorMessage = error.localizedDescription } }
}
