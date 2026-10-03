import Foundation

/// A catalogue topic; the selected one is shown in the split view's detail column.
enum FeatureRoute: Hashable {
    case deviceInfo
    case urlSession
    case firebase
    case security(SecurityRoute)
}

/// A screen pushed inside the detail column's navigation stack.
enum DetailRoute: Hashable {
    case response(HttpResponse)
}
