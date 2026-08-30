import Foundation

enum FeatureRoute: Hashable {
    case catalog(DashboardCategory)
    case deviceInfo
    case urlSession
    case firebase
    case response(HttpResponse)
}

enum DashboardCategory: String, CaseIterable, Identifiable, Hashable {
    case swiftUI
    case httpClient
    case security
    case integration
    case others

    var id: Self { self }

    var title: String {
        switch self {
        case .swiftUI: "SwiftUI"
        case .httpClient: "HTTP Client"
        case .security: "Security"
        case .integration: "Integration"
        case .others: "Others"
        }
    }

    var dashboardDescription: String {
        switch self {
        case .swiftUI: "Modern iOS UI."
        case .httpClient: "Native and library networking."
        case .security: "Screen-capture protection."
        case .integration: "External SDKs and services."
        case .others: "Platform and device details."
        }
    }

    var catalogDescription: String {
        switch self {
        case .swiftUI: "A practical index of the SwiftUI building blocks used in iOS interfaces."
        case .httpClient: "Compare Apple's native networking stack with a popular HTTP client library."
        case .security: "Screen-capture and recording signals for protecting sensitive content."
        case .integration: "External SDKs and services connected to the iOS app."
        case .others: "iOS platform information available on the current device."
        }
    }

    var systemImage: String {
        switch self {
        case .swiftUI: "swift"
        case .httpClient: "network"
        case .security: "lock.shield"
        case .integration: "puzzlepiece.extension"
        case .others: "slider.horizontal.3"
        }
    }

    var items: [CatalogItem] {
        switch self {
        case .swiftUI:
            [
                CatalogItem("Views & modifiers", "Composition, styling, and reusable view behavior."),
                CatalogItem("Layouts", "Stacks, grids, alignment, and adaptive arrangements."),
                CatalogItem("Text & input", "Text, text fields, focus, and user-input patterns."),
                CatalogItem("Buttons & actions", "Buttons, menus, context actions, and touch targets."),
                CatalogItem("Selection", "Pickers, toggles, and multi-selection patterns."),
                CatalogItem("Lists & grids", "Lazy collections and data-driven presentation."),
                CatalogItem("Navigation", "Stacks, split views, destinations, and deep links."),
                CatalogItem("Animation", "State-driven transitions and motion."),
                CatalogItem("Drawing & graphics", "Shapes, Canvas, images, and custom visuals."),
                CatalogItem("Accessibility & testing", "Semantics, Dynamic Type, and UI tests.")
            ]
        case .httpClient:
            [
                CatalogItem("URLSession", "Native async HTTP request sample.", route: .urlSession),
                CatalogItem("Alamofire", "A popular Swift HTTP networking library.")
            ]
        case .security:
            [
                CatalogItem("Screenshot detection", "Observe screenshots after the system captures them."),
                CatalogItem("Screen capture detection", "Observe active recording, mirroring, or AirPlay capture."),
                CatalogItem("Sensitive content", "Reduce exposure while the app is inactive or captured.")
            ]
        case .integration:
            [CatalogItem("Firebase", "Analytics, Config, Crashlytics, Performance, and Messaging.", route: .firebase)]
        case .others:
            [CatalogItem("OS & hardware", "Inspect iOS and the current device hardware.", route: .deviceInfo)]
        }
    }
}

struct CatalogItem: Identifiable, Hashable {
    let title: String
    let description: String
    let route: FeatureRoute?

    var id: String { title }

    init(_ title: String, _ description: String, route: FeatureRoute? = nil) {
        self.title = title
        self.description = description
        self.route = route
    }
}

struct HttpResponse: Hashable {
    let statusCode: Int
    let body: String
    let headers: [(String, String)]

    static func == (lhs: HttpResponse, rhs: HttpResponse) -> Bool {
        lhs.statusCode == rhs.statusCode && lhs.body == rhs.body && lhs.headers.elementsEqual(rhs.headers) { $0.0 == $1.0 && $0.1 == $1.1 }
    }
    func hash(into hasher: inout Hasher) { hasher.combine(statusCode); hasher.combine(body); headers.forEach { hasher.combine($0.0); hasher.combine($0.1) } }
}

enum HttpMethod: String, CaseIterable, Identifiable {
    case GET, POST, PUT, DELETE

    var id: String { rawValue }
    var supportsPayload: Bool { self == .POST || self == .PUT }
}

struct InfoRow: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}
