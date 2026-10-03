import Foundation

/// A catalogue topic; the selected one is shown in the split view's detail column.
/// The raw value is the `route` string used in `navigation.json`.
enum FeatureRoute: String, CaseIterable, Decodable, Hashable {
    case deviceInfo
    case urlSession
    case firebase
    case blockAppDuringCalls
}

/// A screen pushed inside the detail column's navigation stack.
enum DetailRoute: Hashable {
    case response(HttpResponse)
}
