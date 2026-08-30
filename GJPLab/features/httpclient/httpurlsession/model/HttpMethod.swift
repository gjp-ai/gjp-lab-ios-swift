import Foundation

enum HttpMethod: String, CaseIterable, Identifiable {
    case GET, POST, PUT, DELETE

    var id: String { rawValue }
    var supportsPayload: Bool { self == .POST || self == .PUT }
}
