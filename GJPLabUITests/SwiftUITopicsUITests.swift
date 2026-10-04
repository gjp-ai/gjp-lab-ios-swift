import XCTest

/// Opens the SwiftUI category from the sidebar and checks its topics.
final class SwiftUITopicsUITests: XCTestCase {

    private let topics = [
        "Views & modifiers",
        "Layouts",
        "Text & input",
        "Buttons & actions",
        "Selection",
        "Lists & grids",
        "Navigation",
        "Animation",
        "Drawing & graphics",
        "Accessibility & testing",
    ]

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testEverySwiftUITopicOpens() throws {
        let app = launchLab()
        openCategory(titled: "SwiftUI", in: app)
        openEveryTopic(topics, inCategory: "SwiftUI", app: app)
    }

    @MainActor
    func testAccessibilityTopicButtonCountsTaps() throws {
        let app = launchLab()
        openCategory(titled: "SwiftUI", in: app)
        tapRow(titled: "Accessibility & testing", in: app)

        let button = app.buttons["accessibility.tapButton"]
        let count = app.staticTexts["accessibility.tapCount"]
        // The sample sits at the bottom of a scroll view.
        for _ in 0..<6 where !button.isHittable {
            app.swipeUp()
        }
        XCTAssertEqual(count.label, "Tapped 0 times")
        button.tap()
        XCTAssertEqual(count.label, "Tapped 1 time")
    }
}
