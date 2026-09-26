import Foundation

struct HttpResponse: Hashable {
    let statusCode: Int
    let body: String
    let headers: [(String, String)]

    static func == (lhs: HttpResponse, rhs: HttpResponse) -> Bool {
        lhs.statusCode == rhs.statusCode && lhs.body == rhs.body && lhs.headers.elementsEqual(rhs.headers) { $0.0 == $1.0 && $0.1 == $1.1 }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(statusCode)
        hasher.combine(body)
        headers.forEach { hasher.combine($0.0); hasher.combine($0.1) }
    }
}
