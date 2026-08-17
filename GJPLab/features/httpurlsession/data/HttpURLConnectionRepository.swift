import Foundation
import os

enum HttpRepositoryError: LocalizedError { case invalidURL; var errorDescription: String? { "Please enter a valid http:// or https:// URL." } }

struct HttpURLConnectionRepository {
    private let logger = Logger(subsystem: "com.ganjianping.lab.is", category: "HttpURLConnection")
    func execute(method: HttpMethod, urlText: String, payload: String) async throws -> HttpResponse {
        guard let url = URL(string: urlText.trimmingCharacters(in: .whitespacesAndNewlines)), ["http", "https"].contains(url.scheme?.lowercased()) else { throw HttpRepositoryError.invalidURL }
        var request = URLRequest(url: url, timeoutInterval: 15); request.httpMethod = method.rawValue; request.setValue("application/json", forHTTPHeaderField: "Accept")
        if method.supportsPayload { request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type"); if !payload.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { request.httpBody = Data(payload.utf8) } }
        logger.debug("Starting \(method.rawValue, privacy: .public) request")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        let body = String(data: data, encoding: .utf8) ?? ""
        let headers = http.allHeaderFields.map { (String(describing: $0.key), String(describing: $0.value)) }.sorted { $0.0.localizedCaseInsensitiveCompare($1.0) == .orderedAscending }
        return HttpResponse(statusCode: http.statusCode, body: prettyJSON(body), headers: headers)
    }
    private func prettyJSON(_ body: String) -> String { guard let data = body.data(using: .utf8), let object = try? JSONSerialization.jsonObject(with: data), let formatted = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]) else { return body }; return String(data: formatted, encoding: .utf8) ?? body }
}
