import Foundation

/// Sidebar categories and their catalogue topics, read from the bundled `navigation.json`.
struct NavigationMenu: Decodable {
    let categories: [NavigationCategory]

    /// The app's menu. A bundled file that fails to decode is a programming error, caught by unit tests.
    static let main: NavigationMenu = {
        do {
            return try load(from: .main)
        } catch {
            fatalError("Invalid navigation.json: \(error)")
        }
    }()

    static func load(from bundle: Bundle) throws -> NavigationMenu {
        guard let url = bundle.url(forResource: "navigation", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try decode(Data(contentsOf: url))
    }

    static func decode(_ data: Data) throws -> NavigationMenu {
        try JSONDecoder().decode(NavigationMenu.self, from: data)
    }

    func category(id: String) -> NavigationCategory? {
        categories.first { $0.id == id }
    }
}

/// A sidebar row and the catalogue it opens.
struct NavigationCategory: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    /// Shown under the title in the sidebar.
    let summary: String
    /// Shown above the topic list in the catalogue.
    let description: String
    let systemImage: String
    let topics: [NavigationTopic]
}

/// A catalogue row; a topic without a route is planned and cannot be opened.
struct NavigationTopic: Decodable, Identifiable, Hashable {
    let title: String
    let description: String
    let route: FeatureRoute?

    var id: String { title }
}
