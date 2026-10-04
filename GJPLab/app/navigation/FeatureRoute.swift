import Foundation

/// A catalogue topic; the selected one is shown in the split view's detail column.
/// The raw value is the `route` string used in `navigation.json`.
enum FeatureRoute: String, CaseIterable, Decodable, Hashable {
    case swiftBasics
    case optionals
    case collections
    case closures
    case typeSemantics
    case protocolsGenerics
    case errorHandling
    case concurrency
    case memory
    case stringsRegex
    case viewsModifiers
    case layouts
    case textInput
    case buttonsActions
    case selection
    case listsGrids
    case navigationPatterns
    case animation
    case drawing
    case accessibility
    case deviceInfo
    case urlSession
    case firebase
    case blockAppDuringCalls
}

/// A screen pushed inside the detail column's navigation stack.
enum DetailRoute: Hashable {
    case response(HttpResponse)
    case navigationLevel(Int)
}
