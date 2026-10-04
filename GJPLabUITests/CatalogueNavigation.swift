import XCTest

/// Helpers for moving through the sidebar and catalogue. Sidebar and catalogue rows combine their title and
/// description into one accessibility label, for example "Optionals, nil, if let, guard let, ??, and optional
/// chaining., Open", so rows are found by "<title>," at the start of the label.
extension XCTestCase {

    /// Waits for the sidebar (the app shows a splash screen first, which waits for at most the Remote Config
    /// timeout) and opens a category.
    @MainActor
    func openCategory(titled title: String, in app: XCUIApplication) {
        let category = element(labelStartingWith: title + ",", in: app)
        XCTAssertTrue(category.waitForExistence(timeout: 20), "Sidebar did not appear after the splash screen")
        category.tap()
        XCTAssertTrue(app.navigationBars[title].waitForExistence(timeout: 5), "\(title) catalogue did not open")
    }

    /// Scrolls the catalogue until the row is fully on screen, then taps it. The list is lazy, so a row that
    /// has never been on screen may not exist yet, and a partly visible row can sit under the bottom edge,
    /// where a tap does not select it.
    @MainActor
    func tapRow(titled title: String, in app: XCUIApplication) {
        let row = element(labelStartingWith: title + ",", in: app)
        let visibleArea = app.windows.firstMatch.frame.insetBy(dx: 0, dy: 100)
        for _ in 0..<6 {
            guard row.waitForExistence(timeout: 1) else {
                // Not created yet: topics are in order, so a missing row is further down the list.
                app.swipeUp()
                continue
            }
            if visibleArea.contains(row.frame) { break }
            // Scroll towards the row: down when it is above the visible area, up when it is below.
            if row.frame.minY < visibleArea.minY {
                app.swipeDown()
            } else {
                app.swipeUp()
            }
        }
        XCTAssertTrue(row.exists, "\(title) row not found")
        row.tap()
    }

    /// Opens each topic in turn and checks its navigation title, returning to the catalogue on iPhone.
    @MainActor
    func openEveryTopic(_ topics: [String], inCategory category: String, app: XCUIApplication) {
        for topic in topics {
            tapRow(titled: topic, in: app)
            XCTAssertTrue(app.navigationBars[topic].waitForExistence(timeout: 5), "\(topic) did not open")
            // On iPhone the split view is one stack: go back to the catalogue. On iPad the catalogue stays visible.
            if !app.navigationBars[category].exists {
                app.navigationBars[topic].buttons.firstMatch.tap()
            }
        }
    }

    @MainActor
    func element(labelStartingWith prefix: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)
            .matching(NSPredicate(format: "label BEGINSWITH %@", prefix))
            .firstMatch
    }
}
