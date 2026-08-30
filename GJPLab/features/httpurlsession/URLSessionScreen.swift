import SwiftUI

struct URLSessionScreen: View {
    @State private var method = HttpMethod.GET
    @State private var url = "https://www.ganjianping.com/api/open/websites?channel=AI&page=0&size=500&lang=EN"
    @State private var payload = "{\n  \"example\": \"value\"\n}"
    @State private var errorMessage: String?
    @State private var isLoading = false

    let onResponse: (HttpResponse) -> Void
    private let repository = URLSessionRepository()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Build and send an HTTP request with Apple's native networking API.")
                    .foregroundStyle(LabTheme.onSurfaceVariant)

                Text("Method").font(.headline)
                Picker("Method", selection: $method) {
                    ForEach(HttpMethod.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .onChange(of: method) { _, _ in errorMessage = nil }

                TextField("https://example.com/api", text: $url, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityLabel("URL")

                if method.supportsPayload {
                    TextField("JSON payload", text: $payload, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(6...12)
                        .font(.system(.body, design: .monospaced))
                        .accessibilityLabel("Request payload")
                }

                if let errorMessage {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(errorMessage).frame(maxWidth: .infinity, alignment: .leading)
                        Button("Dismiss") { self.errorMessage = nil }
                    }
                    .foregroundStyle(LabTheme.onErrorContainer)
                    .padding(14)
                    .background(LabTheme.errorContainer, in: RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    Task { await send() }
                } label: {
                    Group {
                        if isLoading {
                            ProgressView().tint(LabTheme.onPrimary)
                        } else {
                            Text("Send request")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading || url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .frame(maxWidth: 720)
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("URLSession")
        .labScreenBackground()
    }

    private func send() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            onResponse(try await repository.execute(method: method, urlText: url, payload: payload))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack { URLSessionScreen(onResponse: { _ in }) }
}
