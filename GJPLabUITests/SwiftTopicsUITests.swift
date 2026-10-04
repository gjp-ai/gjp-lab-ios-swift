import XCTest

/// Opens the Swift category from the sidebar, checks its topics, and runs one sample.
final class SwiftTopicsUITests: XCTestCase {

    private let topics = [
        "Values & types",
        "Optionals",
        "Collections",
        "Functions & closures",
        "Structs, classes & enums",
        "Protocols & generics",
        "Error handling",
        "Concurrency",
        "Memory management",
        "Strings & regex",
    ]

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testSwiftIsTheFirstCategory() throws {
        let app = XCUIApplication()
        app.launch()
        let swift = element(labelStartingWith: "Swift,", in: app)
        let swiftUI = element(labelStartingWith: "SwiftUI,", in: app)
        XCTAssertTrue(swift.waitForExistence(timeout: 20), "Sidebar did not appear after the splash screen")
        XCTAssertLessThan(swift.frame.minY, swiftUI.frame.minY)
    }

    @MainActor
    func testEverySwiftTopicOpens() throws {
        let app = XCUIApplication()
        app.launch()
        openCategory(titled: "Swift", in: app)
        openEveryTopic(topics, inCategory: "Swift", app: app)
    }

    @MainActor
    func testRunShowsTheSampleOutput() throws {
        let app = XCUIApplication()
        app.launch()
        openCategory(titled: "Swift", in: app)
        tapRow(titled: "Values & types", in: app)

        let run = app.buttons.matching(identifier: "codeSample.run").firstMatch
        XCTAssertTrue(run.waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["codeSample.output"].exists, "Output shown before Run")
        run.tap()

        let output = app.staticTexts.matching(identifier: "codeSample.output").firstMatch
        XCTAssertTrue(output.waitForExistence(timeout: 5))
        XCTAssertTrue(output.label.hasPrefix("score: 65 of 100"), "Unexpected output: \(output.label)")
    }
}
