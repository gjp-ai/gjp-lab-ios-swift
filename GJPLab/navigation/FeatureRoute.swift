import Foundation

enum FeatureRoute: Hashable {
    case catalog(DashboardCategory)
    case deviceInfo
    case urlSession
    case firebase
    case security(SecurityRoute)
    case response(HttpResponse)
}
