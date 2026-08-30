import Foundation

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
        case .swiftUI: "Apple’s modern framework for building UI declaratively."
        case .httpClient: "URLSession, Alamofire, Moya, Siesta"
        case .security: "Runtime Application Self-Protection"
        case .integration: "External SDKs and services. eg: Firebase"
        case .others: "Platform and device details, Biometric ID, and more."
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
            SecurityCatalog.items
        case .integration:
            [CatalogItem("Firebase", "Analytics, Config, Crashlytics, Performance, and Messaging.", route: .firebase)]
        case .others:
            [CatalogItem("OS & hardware", "Inspect iOS and the current device hardware.", route: .deviceInfo)]
        }
    }
}
