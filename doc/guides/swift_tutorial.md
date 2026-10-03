# Swift tutorial

Learn the Swift language features that GJPLab actually uses, one lesson at a time, with every example taken from this project's source code.

**Who this is for:** developers who know basic programming (variables, functions, loops) but are new to Swift.

**How to use it:** read a lesson, open the linked file in Xcode, find the snippet, then do the **Try it** exercise. Lessons build on each other, so read them in order the first time.

**Versions:** Swift 5 language mode, iOS 26.6 deployment target, Xcode 27. The app target uses default `MainActor` isolation (see [lesson 13](#13-concurrency-async-await-and-tasks)).

**Next:** the [SwiftUI tutorial](swiftui_tutorial.md) builds on these lessons.

## Contents

1. [Constants, variables, and type inference](#1-constants-variables-and-type-inference)
2. [Optionals](#2-optionals)
3. [Structs and classes](#3-structs-and-classes)
4. [Enums](#4-enums)
5. [`switch` and pattern matching](#5-switch-and-pattern-matching)
6. [Computed properties and property observers](#6-computed-properties-and-property-observers)
7. [Access control](#7-access-control)
8. [Protocols](#8-protocols)
9. [Extensions](#9-extensions)
10. [Closures and higher-order functions](#10-closures-and-higher-order-functions)
11. [Error handling](#11-error-handling)
12. [`Codable` and JSON](#12-codable-and-json)
13. [Concurrency: `async`, `await`, and tasks](#13-concurrency-async-await-and-tasks)
14. [Static members and one-time setup](#14-static-members-and-one-time-setup)

[Reading path, pitfalls, and glossary](#reading-path-pitfalls-and-glossary)

---

## Lessons

### 1. Constants, variables, and type inference

`let` declares a constant (it cannot change); `var` declares a variable. Swift infers the type from the value, so you rarely write types by hand. Prefer `let` unless the value must change.

From [`AppConfig.swift`](../../GJPLab/common/config/AppConfig.swift):

```swift
static let minimumSplashDuration: Duration = .seconds(3)
static let isBlockAppDuringCall: Bool = true
```

From [`URLSessionRepository.swift`](../../GJPLab/features/httpclient/urlsession/URLSessionRepository.swift):

```swift
let trimmedURL = urlText.trimmingCharacters(in: .whitespacesAndNewlines)  // inferred String
var request = URLRequest(url: url, timeoutInterval: 15)                   // var: changed below
request.httpMethod = method.rawValue
```

`request` is a `var` because the next lines change it. `.seconds(3)` is shorthand for `Duration.seconds(3)`: when Swift already knows the type, you can drop it and start with a dot.

**String interpolation** puts values inside text with `\( )`:

```swift
logger.debug("Received HTTP \(http.statusCode) response (\(data.count) bytes)")
```

**Try it:** change `minimumSplashDuration` to `.seconds(1)`, run the app, and watch the splash shorten. Change it back.

### 2. Optionals

An optional (`String?`) holds either a value or `nil` ("no value"). Swift will not let you use an optional as if it were a value; you must unwrap it first. This prevents a whole class of crashes.

| Tool | Meaning | Project example |
| --- | --- | --- |
| `if let x` | Run the block only if there is a value | `if let errorMessage { … }` in [`URLSessionScreen`](../../GJPLab/features/httpclient/urlsession/URLSessionScreen.swift) |
| `guard let x else { return }` | Leave early if there is no value; `x` is usable afterwards | URL checks in `URLSessionRepository.execute` |
| `??` | Use a fallback when `nil` | `String(data: data, encoding: .utf8) ?? ""` |
| `?.` | Call only if not `nil`; the result is optional | `callObserver?.calls.contains { … } ?? false` |
| `as?` | Try to convert a type; `nil` if it fails | `response as? HTTPURLResponse` |
| `.map` on an optional | Transform the value if present | `screen.map { "\(Int($0.width)) × …" } ?? "Unknown"` |

The guard in `URLSessionRepository` checks three things in one statement and throws if any fails:

```swift
guard
    let url = URL(string: trimmedURL),
    let scheme = url.scheme?.lowercased(),
    ["http", "https"].contains(scheme)
else {
    throw URLSessionRepositoryError.invalidURL
}
// From here on, `url` and `scheme` are non-optional.
```

`if let errorMessage` (without `= errorMessage`) is shorthand for `if let errorMessage = errorMessage`.

[`BlockAppDuringCallsController`](../../GJPLab/features/security/blockappduringcalls/BlockAppDuringCallsController.swift) combines `as?` and `??` to read a saved setting with a default:

```swift
isEnabled = UserDefaults.standard.object(forKey: DefaultsKey.isEnabled) as? Bool ?? AppConfig.isBlockAppDuringCall
```

Avoid force unwrapping (`value!`): it crashes when the value is `nil`. The project uses it only in previews, where a missing value is a coding mistake: `NavigationMenu.main.category(id: "httpClient")!`.

**Try it:** in `URLSessionScreen`, type `ftp://example.com` and press **Send request**. Follow the `guard` that produces the error message.

### 3. Structs and classes

Both group data and functions, but they behave differently when copied:

| | `struct` (value type) | `class` (reference type) |
| --- | --- | --- |
| Copying | Makes an independent copy | Shares the same object |
| Typical use | Data, small helpers, SwiftUI views | Long-lived objects with identity, delegates, `ObservableObject` |
| Project examples | `HttpResponse`, `InfoRow`, `NavigationCategory`, `URLSessionRepository`, every `View` | `BlockAppDuringCallsController`, `FirebaseIntegration`, `GJPLabAppDelegate` |

Default to a `struct`. The project uses a `class` only when something must be shared and stay the same object, such as the call-blocking controller that both the app overlay and the settings screen read.

```swift
struct HttpResponse: Hashable {        // a plain value
    let statusCode: Int
    let body: String
    let headers: [(String, String)]
}

@MainActor
final class BlockAppDuringCallsController: NSObject, ObservableObject { … }
```

`final` means no other class can inherit from it, which is the right default. `NSObject` is required here because CallKit's delegate API comes from Objective-C.

Structs get a free **memberwise initializer**: `HttpResponse(statusCode: 200, body: "", headers: [])`. Classes must write `init` themselves, and must set every stored property before calling `super.init()`, as `BlockAppDuringCallsController.init` does.

### 4. Enums

An enum lists a fixed set of cases. GJPLab uses four flavours.

**Raw values** give each case a stored value. [`HttpMethod`](../../GJPLab/features/httpclient/urlsession/HttpMethod.swift) uses `String` raw values, so `.GET.rawValue == "GET"`:

```swift
enum HttpMethod: String, CaseIterable, Identifiable {
    case GET, POST, PUT, DELETE

    var id: String { rawValue }
    var supportsPayload: Bool { self == .POST || self == .PUT }
}
```

`CaseIterable` adds `HttpMethod.allCases`, which the screen loops over to build the method picker.

[`FeatureRoute`](../../GJPLab/app/navigation/FeatureRoute.swift) uses raw values to connect Swift to JSON: the `"route": "urlSession"` string in `navigation.json` becomes `FeatureRoute.urlSession`.

**Associated values** attach data to a case. [`DetailRoute`](../../GJPLab/app/navigation/FeatureRoute.swift) carries the response to show:

```swift
enum DetailRoute: Hashable {
    case response(HttpResponse)
}
```

**Nested enums** keep related values inside the type that uses them, such as `BlockAppDuringCallsController.Availability` (`.checking`, `.available`, `.unavailableInChina`, `.unavailable`).

**Caseless enums as namespaces** group constants. An enum with no cases cannot be created by mistake, which makes it a tidy container: [`LabTheme`](../../GJPLab/common/theme/LabTheme.swift), [`AppConfig`](../../GJPLab/common/config/AppConfig.swift), and [`FirebaseConstants`](../../GJPLab/features/integration/firebase/FirebaseConstants.swift).

**Try it:** add `case PATCH` to `HttpMethod`. The picker gains a button automatically, because it loops over `allCases`. Decide whether `PATCH` should send a payload, update `supportsPayload`, then remove the case.

### 5. `switch` and pattern matching

Swift's `switch` must cover every case, so the compiler tells you when you forget one. It can also match ranges. Since Swift 5.9, `switch` and `if` can be used as expressions that return a value, which the project uses for short mappings.

From [`HttpResponseScreen`](../../GJPLab/features/httpclient/urlsession/HttpResponseScreen.swift):

```swift
private var statusColor: Color {
    switch response.statusCode {
    case 200...299: LabTheme.success   // closed range: 200 through 299
    case 400...599: LabTheme.error
    default: LabTheme.onSurface
    }
}
```

From `BlockAppDuringCallsScreen`, a switch over an enum with no `default`, so adding a new `Availability` case forces you to handle it here:

```swift
switch controller.availability {
case .checking: "Checking availability"
case .available: controller.isEnabled ? "On" : "Off"
case .unavailableInChina: "Unavailable in China"
case .unavailable: "Unavailable"
}
```

[`ContentView.feature(for:)`](../../GJPLab/app/ContentView.swift) uses a switch to turn each `FeatureRoute` into its screen; this is the one place where a route becomes a view.

### 6. Computed properties and property observers

A **computed property** has no storage; it calculates its value each time it is read. Use one for values derived from other state, so they can never get out of sync.

```swift
// BlockAppDuringCallsController
var isBlocking: Bool {
    isEnabled && availability == .available && (hasActiveCall || isTestCallActive)
}

// NavigationCategory in NavigationMenu.swift
var availableTopicCount: Int {
    topics.filter { $0.route != nil }.count
}
```

A **property observer** runs code when a stored property changes. `didSet` here saves the setting every time it changes:

```swift
@Published var isEnabled: Bool {
    didSet { UserDefaults.standard.set(isEnabled, forKey: DefaultsKey.isEnabled) }
}
```

### 7. Access control

| Keyword | Visible to | Project example |
| --- | --- | --- |
| `private` | The enclosing declaration (and its extensions in the same file) | `private func prettyJSON`, `private struct CatalogRow` |
| `private(set)` | Everyone can read; only the type can write | `@Published private(set) var availability` |
| *(none)* = `internal` | The whole app target | Most types |

Make things `private` unless other files need them. Helper views such as `ResponseBlock`, `InfoSection`, and `FirebaseActionCard` are `private struct`s because only one screen uses each.

`private(set)` on `availability` lets the screen read the value but stops it from changing it; only the controller decides availability.

### 8. Protocols

A protocol is a list of requirements; a type that "conforms" promises to meet them. Most conformances in the project come from the standard library or SwiftUI:

| Protocol | What it gives you | Project example |
| --- | --- | --- |
| `Identifiable` | An `id`, so SwiftUI can tell items apart in lists | `NavigationTopic`, `InfoRow`, `HttpMethod` |
| `Hashable` | Usable in sets, as dictionary keys, and as navigation and selection values | `FeatureRoute`, `DetailRoute`, `HttpResponse` |
| `Equatable` | `==` comparison | `Availability` |
| `Decodable` | Can be created from JSON | `NavigationMenu`, `NavigationCategory`, `FeatureRoute` |
| `LocalizedError` | A user-readable `errorDescription` | `URLSessionRepositoryError` |
| `View` | Can be shown by SwiftUI | Every screen |
| `ObservableObject` | SwiftUI can watch it for changes | `FirebaseIntegration` |

Swift usually writes `Hashable` and `Equatable` for you. [`HttpResponse`](../../GJPLab/features/httpclient/urlsession/HttpResponse.swift) has to write them by hand because tuples such as `(String, String)` are not `Hashable`:

```swift
static func == (lhs: HttpResponse, rhs: HttpResponse) -> Bool {
    lhs.statusCode == rhs.statusCode && lhs.body == rhs.body
        && lhs.headers.elementsEqual(rhs.headers) { $0.0 == $1.0 && $0.1 == $1.1 }
}
```

**Your own protocol.** [`AppSDKBootstrapper`](../../GJPLab/app/AppSDKBootstrapper.swift) defines `SDKIntegration` and keeps an array of anything that conforms. Adding an SDK means adding one conforming type to the array; the bootstrapper's code does not change:

```swift
protocol SDKIntegration {
    func configure(application: UIApplication)
    func didRegisterForRemoteNotifications(with deviceToken: Data)
    func didFailToRegisterForRemoteNotifications(with error: Error)
}

private let integrations: [SDKIntegration] = [FirebaseStartupIntegration()]
```

**Delegates** are protocols used for callbacks from Apple frameworks: `GJPLabAppDelegate` conforms to `UIApplicationDelegate`, `FirebaseMessagingHandler` to `MessagingDelegate` and `UNUserNotificationCenterDelegate`, and the call controller to `CXCallObserverDelegate`.

### 9. Extensions

An extension adds methods, computed properties, initializers, or protocol conformances to an existing type, even one you did not write.

**Adding methods to SwiftUI's `View`**, so every view can call `.labCard()` (from [`LabTheme.swift`](../../GJPLab/common/theme/LabTheme.swift)):

```swift
extension View {
    func labCard(cornerRadius: CGFloat = 24) -> some View {
        background(LabTheme.surface, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.08), radius: 7, y: 2)
    }
}
```

**Adding a private initializer** to `Color`, visible only inside this file:

```swift
private extension Color {
    init(light: UInt32, dark: UInt32) { … }
}
```

**Grouping a conformance**: `BlockAppDuringCallsController` adopts `CXCallObserverDelegate` in a separate `extension` at the bottom of the file, which keeps the delegate code in one place.

`cornerRadius: CGFloat = 24` is a **default parameter value**: callers may write `.labCard()` or `.labCard(cornerRadius: 18)`.

### 10. Closures and higher-order functions

A closure is a function without a name that you can store or pass around. `{ $0.route != nil }` is a closure; `$0` is its first argument.

**Trailing closure syntax**: when the last argument is a closure, write it after the parentheses. SwiftUI uses this everywhere:

```swift
Button("Dismiss") { self.errorMessage = nil }   // same as Button("Dismiss", action: { … })
```

**Closures as properties (callbacks).** [`URLSessionScreen`](../../GJPLab/features/httpclient/urlsession/URLSessionScreen.swift) does not decide where the response goes. It receives a closure and calls it, and `ContentView` decides to push the response screen:

```swift
let onResponse: (HttpResponse) -> Void       // URLSessionScreen

URLSessionScreen(onResponse: { response in   // ContentView
    guard selectedTopic == .urlSession else { return }
    detailPath.append(.response(response))
})
```

**Higher-order functions** process collections without manual loops:

| Function | Does | Project example |
| --- | --- | --- |
| `map` | Transform each element | Header pairs → `"Name: value"` lines in `HttpResponseScreen` |
| `filter` | Keep matching elements | `topics.filter { $0.route != nil }` |
| `compactMap` | Transform and drop `nil`s | `.compactMap(\.route)` in the unit tests |
| `flatMap` | Transform and flatten nested arrays | `categories.flatMap(\.topics)` |
| `first(where:)` | First match, or `nil` | `categories.first { $0.id == id }` |
| `contains(where:)` | Is any element a match? | `calls.contains(where: { !$0.hasEnded })` |
| `sorted(by:)` | Sort with a rule | Headers sorted case-insensitively in `URLSessionRepository` |
| `forEach` | Run code for each element | `integrations.forEach { $0.configure(application: application) }` |

`\.route` is a **key path**: a reference to a property, usable wherever a closure like `{ $0.route }` is expected.

**`[weak self]`** stops a closure from keeping an object alive forever. The call controller uses it in tasks that may outlive the object:

```swift
Task { [weak self] in
    let storefront = await Storefront.current
    self?.configure(for: storefront?.countryCode)  // self may be nil by now
}
```

### 11. Error handling

A function marked `throws` can fail. Callers must mark the call with `try` and handle the error.

| Syntax | Use when | Project example |
| --- | --- | --- |
| `do { try … } catch { … }` | You want to handle the error | `URLSessionScreen.send()` shows `error.localizedDescription` |
| `try?` | Failure should just give `nil` | `try? JSONSerialization.jsonObject(with: data)` |
| `throw` | Your code detects a failure | `throw URLSessionRepositoryError.invalidURL` |
| `fatalError` | Failure is a programming mistake that tests should catch | Invalid bundled `navigation.json` in `NavigationMenu.main` |

A custom error is usually an enum conforming to `LocalizedError`, so the message shown to users lives next to the error:

```swift
enum URLSessionRepositoryError: LocalizedError {
    case invalidURL
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL: "Please enter a valid http:// or https:// URL."
        case .invalidResponse: "The server returned a response iOS could not interpret."
        }
    }
}
```

**`defer`** runs code when the current scope ends, however it ends. `URLSessionScreen.send()` uses it so the loading spinner always stops, whether the request succeeds or throws:

```swift
isLoading = true
defer { isLoading = false }
do { onResponse(try await repository.execute(…)) } catch { errorMessage = error.localizedDescription }
```

### 12. `Codable` and JSON

`Decodable` types are built from JSON automatically when their property names match the JSON keys. [`NavigationMenu.swift`](../../GJPLab/app/navigation/NavigationMenu.swift) decodes [`navigation.json`](../../GJPLab/app/navigation/navigation.json):

```swift
struct NavigationTopic: Decodable, Identifiable, Hashable {
    let title: String
    let description: String
    let route: FeatureRoute?   // optional: a missing "route" key decodes as nil (a planned topic)
    var id: String { title }   // computed, so it is not read from JSON
}

static func decode(_ data: Data) throws -> NavigationMenu {
    try JSONDecoder().decode(NavigationMenu.self, from: data)
}
```

Three details matter:

- An **optional** property may be missing from the JSON.
- **Computed** properties such as `id` are ignored by the decoder.
- `FeatureRoute` is a `String` enum, so a `"route"` value that matches no case makes decoding **throw**. A unit test checks exactly this.

For JSON with no fixed shape, `URLSessionRepository.prettyJSON` uses the older `JSONSerialization` API to re-format any response.

**Try it:** add a planned topic (no `"route"`) to the Others category in `navigation.json` and run the app; it appears with a clock icon. Then add `"route": "typo"` to it and run the unit tests to see them fail. Remove the topic.

### 13. Concurrency: `async`, `await`, and tasks

Slow work (network, timers, system queries) is written with `async` functions. `await` marks a point where the function may pause without blocking the app.

```swift
// URLSessionRepository
func execute(method: HttpMethod, urlText: String, payload: String) async throws -> HttpResponse {
    let (data, response) = try await URLSession.shared.data(for: request)
    try Task.checkCancellation()   // stop if the caller no longer needs the result
    …
}
```

**Starting async work from a button.** A button action is not `async`, so wrap the call in `Task { }`:

```swift
Button { Task { await send() } } label: { … }
```

**Running work in parallel with `async let`.** [`GJPLabApp`](../../GJPLab/app/GJPLabApp.swift) starts the maintenance check and the 3-second splash timer at the same time, then waits for both:

```swift
async let fetchedMaintenanceMode = loadMaintenanceMode()   // starts now
try? await Task.sleep(for: AppConfig.minimumSplashDuration) // runs meanwhile
maintenanceEnabled = await fetchedMaintenanceMode           // wait for the result
```

**A timeout with a task group.** `loadMaintenanceMode()` races the Firebase fetch against a 5-second sleep; whichever finishes first wins and the other is cancelled:

```swift
await withTaskGroup(of: Bool?.self) { group in
    group.addTask { await firebaseIntegration.fetchMaintenanceMode() }
    group.addTask { try? await Task.sleep(for: AppConfig.remoteConfigTimeout); return nil }
    let result = await group.next() ?? nil
    group.cancelAll()
    return result ?? false   // timeout or failure → not in maintenance
}
```

**`MainActor`: which thread runs your code.** UI must be updated on the main thread. This project turns on *default `MainActor` isolation*, so code in the app runs on the main actor unless marked otherwise. Two cases need care:

- Work that should run off the main thread is marked `nonisolated` or `@concurrent`.
- A callback from a framework may arrive on another thread. The call controller marks the delegate method `nonisolated` and hops back to the main actor before touching its state:

```swift
nonisolated func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
    Task { @MainActor [weak self] in
        self?.refreshCallStatus()
    }
}
```

### 14. Static members and one-time setup

`static` members belong to the type, not to an instance: `LabTheme.primary`, `AppConfig.remoteConfigTimeout`. A `static let` is created once, the first time it is used.

`NavigationMenu.main` uses a closure that runs once to load and decode the JSON:

```swift
static let main: NavigationMenu = {
    do {
        return try load(from: .main)
    } catch {
        fatalError("Invalid navigation.json: \(error)")
    }
}()   // the () runs the closure immediately
```

---

## Reading path, pitfalls, and glossary

### Suggested reading order

Read the source in this order; each file adds a few new language ideas.

| # | File | New ideas |
| --- | --- | --- |
| 1 | [`AppConfig.swift`](../../GJPLab/common/config/AppConfig.swift) | `let`, `static`, caseless enum |
| 2 | [`HttpMethod.swift`](../../GJPLab/features/httpclient/urlsession/HttpMethod.swift) | Raw-value enum, `CaseIterable`, computed property |
| 3 | [`HttpResponse.swift`](../../GJPLab/features/httpclient/urlsession/HttpResponse.swift) | Struct, hand-written `Hashable` |
| 4 | [`URLSessionRepository.swift`](../../GJPLab/features/httpclient/urlsession/URLSessionRepository.swift) | `guard`, `async throws`, custom errors, closures |
| 5 | [`NavigationMenu.swift`](../../GJPLab/app/navigation/NavigationMenu.swift) and [`navigation.json`](../../GJPLab/app/navigation/navigation.json) | `Decodable`, optionals in JSON, `static let` setup |
| 6 | [`AppSDKBootstrapper.swift`](../../GJPLab/app/AppSDKBootstrapper.swift) | Your own protocol, arrays of protocol types |
| 7 | [`BlockAppDuringCallsController.swift`](../../GJPLab/features/security/blockappduringcalls/BlockAppDuringCallsController.swift) | Classes, `didSet`, `private(set)`, delegates, `MainActor` |
| 8 | [`GJPLabApp.swift`](../../GJPLab/app/GJPLabApp.swift) | `async let`, task groups, timeouts |

### Common pitfalls

| Pitfall | What happens | Do this instead |
| --- | --- | --- |
| Force unwrapping `!` in app code | Crash when the value is `nil` | `if let`, `guard let`, or `??` ([lesson 2](#2-optionals)) |
| `try?` where the user needs to know what failed | The error disappears silently | `do`/`catch` and show `error.localizedDescription` ([lesson 11](#11-error-handling)) |
| Updating UI state from a background callback | Data races and warnings | Hop to `@MainActor` ([lesson 13](#13-concurrency-async-await-and-tasks)) |
| A `class` for plain data | Shared changes in unexpected places | Default to a `struct` ([lesson 3](#3-structs-and-classes)) |
| A `switch` with `default` over your own enum | New cases are silently unhandled | List every case so the compiler checks ([lesson 5](#5-switch-and-pattern-matching)) |

### Glossary

| Term | Meaning |
| --- | --- |
| Closure | A function without a name that can be stored or passed, such as `{ $0.route != nil }` |
| Conformance | A type promising to meet a protocol's requirements |
| Key path | A reference to a property, such as `\.route` |
| `MainActor` | The main thread's actor; UI code must run there |
| Optional | A value that may be `nil`, written `Type?` |
| Protocol | A list of requirements that types can promise to meet |
| Raw value | A fixed value stored in each enum case, such as `"GET"` |
| Reference type | A type (class) whose variables share one object |
| Value type | A type (struct or enum) that is copied on assignment |

### Further reading

- [The Swift Programming Language](https://docs.swift.org/swift-book/) — the official language guide.
- Next in this repository: the [SwiftUI tutorial](swiftui_tutorial.md).
