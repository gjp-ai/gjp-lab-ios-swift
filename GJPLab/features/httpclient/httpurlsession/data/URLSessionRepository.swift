import Foundation
import os

enum URLSessionRepositoryError: LocalizedError {
    case invalidURL
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL: "Please enter a valid http:// or https:// URL."
        case .invalidResponse: "The server returned a response iOS could not interpret."
        }
    }
}

struct URLSessionRepository {
    private let logger = Logger(subsystem: "com.ganjianping.lab.is", category: "URLSession")

    func execute(method: HttpMethod, urlText: String, payload: String) async throws -> HttpResponse {
        let trimmedURL = urlText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            let url = URL(string: trimmedURL),
            let scheme = url.scheme?.lowercased(),
            ["http", "https"].contains(scheme)
        else {
            throw URLSessionRepositoryError.invalidURL
        }

        var request = URLRequest(url: url, timeoutInterval: 15)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if method.supportsPayload {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            if !payload.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                request.httpBody = Data(payload.utf8)
            }
        }

        logger.debug("Starting \(method.rawValue, privacy: .public) request")
        let (data, response) = try await URLSession.shared.data(for: request)
        try Task.checkCancellation()
        guard let http = response as? HTTPURLResponse else {
            throw URLSessionRepositoryError.invalidResponse
        }

        let body = String(data: data, encoding: .utf8) ?? ""
        let headers = http.allHeaderFields
            .map { (String(describing: $0.key), String(describing: $0.value)) }
            .sorted { $0.0.localizedCaseInsensitiveCompare($1.0) == .orderedAscending }
        logger.debug("Received HTTP \(http.statusCode) response (\(data.count) bytes)")
        return HttpResponse(statusCode: http.statusCode, body: prettyJSON(body), headers: headers)
    }

    private func prettyJSON(_ body: String) -> String {
        guard
            let data = body.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: data),
            JSONSerialization.isValidJSONObject(object),
            let formatted = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
        else {
            return body
        }
        return String(data: formatted, encoding: .utf8) ?? body
    }
}
