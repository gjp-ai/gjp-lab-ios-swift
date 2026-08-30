import Foundation

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
