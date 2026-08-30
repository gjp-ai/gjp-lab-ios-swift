import Foundation

enum SecurityCatalog {
    static let items: [CatalogItem] = [
        CatalogItem(
            "Block App During Calls",
            "Block access while a supported phone or CallKit call is active.",
            route: .security(.blockAppDuringCalls)
        ),
        CatalogItem("Screenshot detection", "Observe screenshots after the system captures them."),
        CatalogItem("Screen capture detection", "Observe active recording, mirroring, or AirPlay capture."),
        CatalogItem("Sensitive content", "Reduce exposure while the app is inactive or captured.")
    ]
}
