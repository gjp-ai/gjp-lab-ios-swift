# SwiftUI tutorial

Learn the SwiftUI features that GJPLab actually uses, one lesson at a time, with every example taken from this project's source code.

**Who this is for:** developers who can read basic Swift and are new to SwiftUI. If optionals, enums, closures, or `async`/`await` are unfamiliar, start with the [Swift tutorial](swift_tutorial.md).

**How to use it:** read a lesson, open the linked file in Xcode, find the snippet, then do the **Try it** exercise. Lessons build on each other, so read them in order the first time.

**Versions:** SwiftUI, iOS 26.6 deployment target, Xcode 27.

## Contents

1. [The app entry point](#1-the-app-entry-point)
2. [Views and `body`](#2-views-and-body)
3. [Layout](#3-layout)
4. [Modifiers and custom modifiers](#4-modifiers-and-custom-modifiers)
5. [State and data flow](#5-state-and-data-flow)
6. [Showing views conditionally](#6-showing-views-conditionally)
7. [Lists, `ForEach`, and selection](#7-lists-foreach-and-selection)
8. [Forms and controls](#8-forms-and-controls)
9. [Navigation](#9-navigation)
10. [Side effects: `.task`, `.onChange`, and the environment](#10-side-effects-task-onchange-and-the-environment)
11. [Theme, dark mode, and drawing](#11-theme-dark-mode-and-drawing)
12. [Accessibility](#12-accessibility)
13. [Previews](#13-previews)
14. [Testing with Swift Testing](#14-testing-with-swift-testing)

[Reading path, pitfalls, and glossary](#reading-path-pitfalls-and-glossary)

---

## Lessons

SwiftUI is **declarative**: you describe what the screen should look like for the current state, and SwiftUI redraws it when the state changes. You never "update a label"; you change state and the label follows.

### 1. The app entry point

[`GJPLabApp.swift`](../../GJPLab/app/GJPLabApp.swift) is where the app starts:

```swift
@main
struct GJPLabApp: App {
    @UIApplicationDelegateAdaptor(GJPLabAppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            …   // the first view: splash, maintenance, or ContentView
        }
    }
}
```

- `@main` marks the entry point; there is exactly one.
- `App` describes the app; its `body` returns **scenes**. `WindowGroup` is the main window (several on iPad).
- `@UIApplicationDelegateAdaptor` connects an old-style UIKit app delegate, which the project needs for push-notification callbacks and SDK startup.

### 2. Views and `body`

A view is a `struct` conforming to `View` with a `body` that returns other views:

```swift
struct SplashScreen: View {
    var body: some View {
        ZStack {
            LabTheme.background.ignoresSafeArea()
            VStack(spacing: 20) { … }
        }
    }
}
```

`some View` means "a specific view type that I do not want to spell out". Views are cheap values that SwiftUI creates and throws away often, so do not do slow work in `init` or `body`.

**Split big screens into small private views.** `HttpResponseScreen` uses `ResponseBlock` three times; `FirebaseFeatureScreen` uses `FirebaseActionCard` five times. Each small view takes its data through `let` properties:

```swift
private struct ResponseBlock: View {
    let title: String
    let value: String
    var monospace = true                 // a var with a default is optional for callers
    var valueColor = LabTheme.onSurface
    var body: some View { … }
}
```

### 3. Layout

| View | Arranges children | Project example |
| --- | --- | --- |
| `VStack` | Top to bottom | Most screens |
| `HStack` | Leading to trailing | Label and value in `InfoSection` |
| `ZStack` | Back to front (layers) | Splash background and logo; app content under `CallBlockingOverlay` |
| `Spacer` | Pushes neighbours apart | Between a catalogue row's text and its chevron |
| `ScrollView` | Scrolls when content is too tall | All feature screens |
| `Divider` | A thin line | Between device-info rows |

`alignment:` and `spacing:` control how children line up, as in `VStack(alignment: .leading, spacing: 16)`.

**The readable-width pattern.** Feature screens use the same three modifiers so content stays at most 720 points wide and centred on iPad, but full width on iPhone:

```swift
VStack { … }
    .frame(maxWidth: 720)          // never wider than 720
    .padding(20)
    .frame(maxWidth: .infinity)    // fill the screen, centring the 720-wide column
```

**Try it:** change `720` to `400` in `DeviceInfoScreen`, run on an iPad simulator, and compare.

### 4. Modifiers and custom modifiers

Modifiers such as `.font(_:)`, `.padding()`, and `.foregroundStyle(_:)` return a new, wrapped view. **Order matters**, because each modifier wraps everything before it:

```swift
.padding(18)                 // 1. add space around the content
.labCard(cornerRadius: 18)   // 2. draw the card behind content + padding
```

Swap them and the padding would sit outside the card.

The project's own modifiers (from [Swift tutorial, lesson 9](swift_tutorial.md#9-extensions)) keep every screen consistent:

- `.labScreenBackground()` sets the Slate canvas colour and default text colour.
- `.labCard(cornerRadius:)` draws the white (or charcoal in dark mode) rounded card with a soft shadow.

Use them, and the `LabTheme` colours, instead of raw colours in feature screens. See the [Slate design system](../specs/common/theme/theme_detail_design.md).

### 5. State and data flow

This is the most important SwiftUI lesson. Each piece of state has **one owner**; other views get access to it.

| Property wrapper | Use for | Project example |
| --- | --- | --- |
| `@State` | Simple values owned by this view | `isLoading`, `url`, `errorMessage` in `URLSessionScreen`; selections in `ContentView` |
| `@Binding` | Read **and write** a value owned by a parent | `@Binding var selection` in `CategorySidebar` and `FeatureCatalogScreen` |
| `@StateObject` | An `ObservableObject` this view **creates and owns** | `FirebaseIntegration` in `FirebaseFeatureScreen`; `callBlocker` in `GJPLabApp` |
| `@ObservedObject` | An `ObservableObject` **passed in** from a parent | `callBlocker` in `ContentView` and `BlockAppDuringCallsScreen` |
| `@Environment` | Values SwiftUI provides | `scenePhase` in `GJPLabApp` |

**`@State` and `$` bindings.** Mark view-owned values `@State private`. Put `$` in front to pass a *binding* that lets a control change the value:

```swift
@State private var method = HttpMethod.GET
…
Picker("Method", selection: $method) { … }   // the picker writes to `method`
```

**`@Binding` in a child.** `ContentView` owns the selected category; the sidebar only receives a binding:

```swift
// ContentView (owner)
@State private var selectedCategory: NavigationCategory?
CategorySidebar(categories: menu.categories, selection: $selectedCategory)

// CategorySidebar (child)
@Binding var selection: NavigationCategory?
```

**Observable objects.** A class that conforms to `ObservableObject` marks changing properties with `@Published`; any view watching it redraws when one changes:

```swift
@MainActor
final class FirebaseIntegration: ObservableObject {
    @Published var analyticsStatus = "No event sent yet"
    …
}
```

**Owner versus observer.** `GJPLabApp` creates the call-blocking controller once with `@StateObject`, so it survives redraws. It passes the same object down; `ContentView` and `BlockAppDuringCallsScreen` use `@ObservedObject` because they do not own it. If a child used `@StateObject` for an object passed in, or a parent used `@ObservedObject` for an object it creates, the object could be recreated or ignored.

`$controller.isEnabled` gives a binding to a `@Published` property, so `Toggle` can change it directly.

> Newer code often uses the `@Observable` macro with plain `@State` instead of `ObservableObject`. This project uses `ObservableObject`; follow the existing pattern unless the project decides to migrate.

**Try it:** in `URLSessionScreen`, change `@State private var isLoading = false` to `private var isLoading = false`. Read the compiler error: a plain property in a view cannot change, because views are values.

### 6. Showing views conditionally

Ordinary `if`, `if let`, and `switch` work inside `body`.

```swift
// GJPLabApp: choose the whole first screen
if showingSplash {
    SplashScreen()
} else if maintenanceEnabled {
    MaintenanceScreen { … }
} else {
    ContentView(callBlocker: callBlocker)
}

// URLSessionScreen: show the error banner only when there is an error
if let errorMessage {
    HStack { … Text(errorMessage) … }
}
```

`Group { }` wraps several conditional branches so one set of modifiers applies to whichever is shown, as on the **Send request** button label (spinner or text).

### 7. Lists, `ForEach`, and selection

`ForEach` builds one view per item. Items must be `Identifiable` (or you pass `id:`), so SwiftUI can track which row is which when the data changes.

```swift
ForEach(HttpMethod.allCases) { Text($0.rawValue).tag($0) }
```

`List(selection:)` makes rows selectable. The selected row's **tag** is written into the binding. [`FeatureCatalogScreen`](../../GJPLab/app/navigation/FeatureCatalogScreen.swift) tags only available topics, so planned topics can never be selected:

```swift
List(selection: $selection) {
    ForEach(category.topics) { topic in
        if let route = topic.route {
            CatalogRow(topic: topic, isAvailable: true).tag(route)
        } else {
            CatalogRow(topic: topic, isAvailable: false)   // no tag → not selectable
        }
    }
}
```

**A real bug from this project.** `List(categories, selection: $selection)` tags each row with the item's `id`. When categories moved to JSON, `id` became a `String`, but the binding expected a `NavigationCategory`, so tapping did nothing. The fix in [`CategorySidebar`](../../GJPLab/app/navigation/CategorySidebar.swift) tags each row with the category itself:

```swift
List(selection: $selection) {
    ForEach(categories) { category in
        CategoryRow(category: category)
            .tag(category)   // tag type must match the selection type
    }
}
```

**Rule:** the tag type must equal the selection binding's type.

**Stable IDs matter.** `InfoRow` uses `let id = UUID()`, which creates a new ID every time the rows are read, so SwiftUI sees "new" rows. It works here because the list never changes, but it is a known gap; prefer an ID that stays the same, such as the label.

### 8. Forms and controls

[`BlockAppDuringCallsScreen`](../../GJPLab/features/security/blockappduringcalls/BlockAppDuringCallsScreen.swift) is a settings-style `Form`; [`URLSessionScreen`](../../GJPLab/features/httpclient/urlsession/URLSessionScreen.swift) builds a custom form in a `ScrollView`.

| Control | Project usage |
| --- | --- |
| `Form` and `Section` (with header and footer) | Call-blocking settings |
| `Toggle` | `Toggle("Block App During Calls", isOn: $controller.isEnabled)` |
| `Picker` with `.pickerStyle(.segmented)` | HTTP method |
| `TextField(…, axis: .vertical)` | URL and JSON payload that grow as you type; `.lineLimit(6...12)` |
| `Button` with `.buttonStyle(.labPrimary)` | Send request, Try again, Firebase actions (a custom `ButtonStyle` in [`LabButtonStyle.swift`](../../GJPLab/common/theme/LabButtonStyle.swift); `.borderedProminent` with the black/white tint made the text unreadable in dark mode) |
| `LabeledContent` | "Status: On" rows |
| `ProgressView` | Spinner while a request runs |
| `.disabled(_:)` | Disable **Send** while loading or when the URL is empty |

Text-input modifiers used for URLs: `.textInputAutocapitalization(.never)` and `.autocorrectionDisabled()`, so iOS does not "fix" the address.

### 9. Navigation

GJPLab uses **one** navigation structure, owned by [`ContentView`](../../GJPLab/app/ContentView.swift):

```swift
NavigationSplitView {
    CategorySidebar(categories: menu.categories, selection: $selectedCategory)    // column 1
} content: {
    FeatureCatalogScreen(category: selectedCategory, selection: $selectedTopic)   // column 2
} detail: {
    NavigationStack(path: $detailPath) {                                          // column 3
        feature(for: selectedTopic)
            .navigationDestination(for: DetailRoute.self) { route in
                switch route {
                case .response(let response): HttpResponseScreen(response: response)
                }
            }
    }
}
```

- **`NavigationSplitView`** shows two or three columns on iPad and collapses into a single stack on iPhone automatically. Navigation is driven by **selection**: choosing a sidebar row sets `selectedCategory`, and the next column appears.
- **`NavigationStack(path:)`** handles pushes inside a feature. `detailPath` is an array of `DetailRoute`. Appending pushes a screen; clearing pops back:

```swift
detailPath.append(.response(response))   // push the response screen
detailPath = []                          // pop to the feature root
```

- **`.navigationDestination(for:)`** maps a route value to its screen.
- **`.navigationTitle`** and `.navigationBarTitleDisplayMode(.inline)` set the title.

Routes are values (enums), not views. That is why `FeatureRoute` and `DetailRoute` are `Hashable`, and why the menu can live in JSON.

The project rule is: do not add other `NavigationStack`s or separate iPhone and iPad navigation code. See [Adding a feature](../architecture/application.md#adding-a-feature).

### 10. Side effects: `.task`, `.onChange`, and the environment

Never start work directly in `body`. Use these modifiers instead:

| Modifier | Runs | Project example |
| --- | --- | --- |
| `.task { }` | Async work when the view appears; cancelled when it disappears | Splash timer and maintenance check in `GJPLabApp` |
| `.onChange(of:)` | When a value changes | Clear the topic when the category changes; clear the push path when the topic changes |
| `Task { }` in an action | Async work after a tap | **Send request**, Firebase buttons |

```swift
// ContentView: keep the three columns consistent
.onChange(of: selectedCategory) { selectedTopic = nil }
.onChange(of: selectedTopic) { detailPath = [] }
```

**Environment values** come from SwiftUI. `scenePhase` tells you whether the app is active, inactive, or in the background; the app re-checks call state when it becomes active again:

```swift
@Environment(\.scenePhase) private var scenePhase
…
.onChange(of: scenePhase) { _, phase in
    if phase == .active { callBlocker.refreshCallStatus() }
}
```

### 11. Theme, dark mode, and drawing

**Colours that follow dark mode.** `LabTheme` builds each colour from a light and a dark value. A `UIColor` with a closure is asked again whenever the appearance changes:

```swift
static let primary = Color(light: 0x000000, dark: 0xFFFFFF)

init(light: UInt32, dark: UInt32) {
    self.init(UIColor { traits in
        UIColor(rgb: traits.userInterfaceStyle == .dark ? dark : light)
    })
}
```

`UIColor(rgb:)` uses **bit shifting** to split `0xRRGGBB` into red, green, and blue: `(rgb >> 16) & 0xFF` is the red byte.

**Custom drawing with `Canvas`.** [`LabMark`](../../GJPLab/common/theme/LabMark.swift) draws the logo with `Path` shapes inside a `Canvas`, scaled with a `CGAffineTransform` so it stays sharp at any size. Reuse `LabMark` rather than copying its paths.

**SF Symbols.** `Image(systemName: "chevron.right")` uses Apple's built-in icon set. Each category's icon name comes from `navigation.json`.

### 12. Accessibility

VoiceOver reads the screen aloud. The project uses these modifiers:

| Modifier | Effect | Project example |
| --- | --- | --- |
| `.accessibilityLabel(_:)` | What VoiceOver says | Catalogue chevron reads "Open", clock reads "Planned"; text fields read "URL" |
| `.accessibilityElement(children: .combine)` | Read a row as one item | Catalogue and sidebar rows |
| `.accessibilityHidden(true)` | Skip decorative images | Category icons, call-overlay icon |
| `.accessibilityHint(_:)` | Extra explanation | "Opens the Security catalogue" |
| `.accessibilityAddTraits(.isModal)` | Keep VoiceOver inside an overlay | `CallBlockingOverlay` |

Text styles such as `.headline` and `.caption` grow with the user's text size (Dynamic Type). `.fixedSize(horizontal: false, vertical: true)` lets long descriptions wrap instead of being cut off.

### 13. Previews

`#Preview` shows a view in Xcode's canvas without running the app. In this project **every preview comes as a pair**, named `"<name> – light"` and `"<name> – dark"`, and screens with several states preview each state:

```swift
#Preview("Available – light") {
    NavigationStack {
        BlockAppDuringCallsScreen(controller: BlockAppDuringCallsController(storefrontCountryCode: "SGP"))
    }
}

#Preview("Available – dark") {
    NavigationStack {
        BlockAppDuringCallsScreen(controller: BlockAppDuringCallsController(storefrontCountryCode: "SGP"))
    }
    .preferredColorScheme(.dark)   // the only difference from the light preview
}

#Preview("SwiftUI catalogue – dark") {
    @Previewable @State var selection: FeatureRoute?
    NavigationStack { FeatureCatalogScreen(category: NavigationMenu.main.category(id: "swiftUI")!, selection: $selection) }
        .preferredColorScheme(.dark)
}
```

- `@Previewable @State` creates state inside a preview, so a view that needs a `@Binding` can be previewed.
- Passing `storefrontCountryCode` lets the preview show the China and non-China states without asking the App Store. This is a simple form of **dependency injection**: give an object its inputs instead of letting it fetch them.

### 14. Testing with Swift Testing

[`GJPLabTests.swift`](../../GJPLabTests/GJPLabTests.swift) uses Swift Testing:

```swift
import Testing
@testable import GJPLab   // see `internal` types from the app

@MainActor @Test func everyFeatureRouteAppearsExactlyOnceInTheMenu() throws {
    let routes = try NavigationMenu.load(from: .main).categories.flatMap(\.topics).compactMap(\.route)
    #expect(routes.count == FeatureRoute.allCases.count)
    #expect(Set(routes) == Set(FeatureRoute.allCases))
}

@MainActor @Test func unknownRouteInNavigationJSONFailsToDecode() {
    let json = Data(#"{"categories":[…"route":"missing"…]}"#.utf8)
    #expect(throws: DecodingError.self) { try NavigationMenu.decode(json) }
}
```

- `@Test` marks a test; `#expect` checks a condition and reports the values when it fails.
- `#expect(throws:)` checks that code throws.
- `#"…"#` is a **raw string**: quotes inside it need no escaping, which suits JSON.
- Tests must be deterministic: no live network or Firebase. The call-blocking tests pass a storefront code instead of asking the App Store.

Run the unit tests with the test command in [`AGENTS.md`](../../AGENTS.md#commands) (add `-only-testing:GJPLabTests`).

---

## Reading path, pitfalls, and glossary

### Suggested reading order

Read the source in this order; each file adds a few new SwiftUI ideas.

| # | File | New ideas |
| --- | --- | --- |
| 1 | [`SplashScreen.swift`](../../GJPLab/app/startup/SplashScreen.swift) | First view, `ZStack`, previews |
| 2 | [`DeviceInfoScreen.swift`](../../GJPLab/features/others/deviceinfo/DeviceInfoScreen.swift) | Private subviews, `ForEach`, readable width |
| 3 | [`LabTheme.swift`](../../GJPLab/common/theme/LabTheme.swift) | Custom modifiers, dark-mode colours |
| 4 | [`URLSessionScreen.swift`](../../GJPLab/features/httpclient/urlsession/URLSessionScreen.swift) | `@State`, bindings, controls, `Task` |
| 5 | [`CategorySidebar.swift`](../../GJPLab/app/navigation/CategorySidebar.swift) and [`FeatureCatalogScreen.swift`](../../GJPLab/app/navigation/FeatureCatalogScreen.swift) | `@Binding`, `List` selection, tags |
| 6 | [`ContentView.swift`](../../GJPLab/app/ContentView.swift) | `NavigationSplitView`, `NavigationStack(path:)`, `.onChange` |
| 7 | [`BlockAppDuringCallsScreen.swift`](../../GJPLab/features/security/blockappduringcalls/BlockAppDuringCallsScreen.swift) | `Form`, `@ObservedObject`, accessibility |
| 8 | [`GJPLabApp.swift`](../../GJPLab/app/GJPLabApp.swift) | `App`, `@StateObject`, `.task`, `scenePhase` |

### Common pitfalls

| Pitfall | What happens | Do this instead |
| --- | --- | --- |
| Selection tag type differs from the binding type | Tapping a row does nothing | Tag rows with the same type as the binding ([lesson 7](#7-lists-foreach-and-selection)) |
| `@ObservedObject` for an object the view creates | The object is recreated and loses its state | Use `@StateObject` in the owner ([lesson 5](#5-state-and-data-flow)) |
| A new `UUID()` as the `id` of recreated data | Rows look "new" on every redraw | Use a stable value as the ID ([lesson 7](#7-lists-foreach-and-selection)) |
| Slow work in `init` or `body` | Stutters, repeated work | Use `.task` or a button `Task` ([lesson 10](#10-side-effects-task-onchange-and-the-environment)) |
| Modifiers in the wrong order | Padding outside the card, backgrounds the wrong size | Read modifiers top to bottom as layers ([lesson 4](#4-modifiers-and-custom-modifiers)) |
| Raw colours in feature views | Breaks dark mode and the Slate look | `LabTheme` roles and `.labCard()` ([lesson 11](#11-theme-dark-mode-and-drawing)) |
| Hard-coding menu text in Swift | The sidebar and catalogue disagree with the JSON | Edit `navigation.json` ([lesson 9](#9-navigation)) |

### Glossary

| Term | Meaning |
| --- | --- |
| Binding | A two-way reference to state owned elsewhere, written `$value` |
| Declarative UI | Describing the UI for a given state instead of changing it step by step |
| Dependency injection | Passing a type the things it needs (here, a storefront code) instead of letting it fetch them |
| Modifier | A method such as `.padding()` that returns a wrapped view |
| Observable object | A class that tells SwiftUI when its `@Published` properties change |
| Scene | A part of the app's UI managed by the system, such as a window |
| Source of truth | The one place that owns a piece of state; everything else reads or binds to it |
| Tag | The value a row writes into a selection binding when chosen |

### Further reading

- [SwiftUI tutorials](https://developer.apple.com/tutorials/swiftui) — Apple's step-by-step SwiftUI course.
- [Swift Testing](https://developer.apple.com/documentation/testing) — the test framework used in `GJPLabTests`.
- In this repository: the [Swift tutorial](swift_tutorial.md), [application architecture](../architecture/application.md), [decision records](../decisions/README.md), and the feature [specs](../specs/).
