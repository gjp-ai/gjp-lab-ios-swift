import Foundation

enum FeatureRoute: Hashable { case deviceInfo, http, firebase, response(HttpResponse) }

struct HttpResponse: Hashable {
    let statusCode: Int
    let body: String
    let headers: [(String, String)]

    static func == (lhs: HttpResponse, rhs: HttpResponse) -> Bool {
        lhs.statusCode == rhs.statusCode && lhs.body == rhs.body && lhs.headers.elementsEqual(rhs.headers) { $0.0 == $1.0 && $0.1 == $1.1 }
    }
    func hash(into hasher: inout Hasher) { hasher.combine(statusCode); hasher.combine(body); headers.forEach { hasher.combine($0.0); hasher.combine($0.1) } }
}

enum HttpMethod: String, CaseIterable, Identifiable { case GET, POST, PUT, DELETE; var id: String { rawValue }; var supportsPayload: Bool { self == .POST || self == .PUT } }
struct InfoRow: Identifiable { let id = UUID(); let label: String; let value: String }
