import CoreGraphics
import Testing
@testable import GJPLab

@MainActor
struct SwiftUIFeatureTests {

    // MARK: Text & input

    @Test func emptySignUpFormReportsEveryProblem() {
        let form = SignUpForm()
        #expect(form.problems.count == 3)
        #expect(!form.isValid)
    }

    @Test func completeSignUpFormIsValid() {
        let form = SignUpForm(name: "Ada", email: "ada@example.com", password: "analytical")
        #expect(form.problems.isEmpty)
        #expect(form.isValid)
    }

    @Test(arguments: ["", "ada", "ada@", "ada@example", "ada @example.com", "@example.com"])
    func invalidEmailIsRejected(email: String) {
        let form = SignUpForm(name: "Ada", email: email, password: "analytical")
        #expect(!form.isValid)
    }

    @Test func whitespaceNameAndShortPasswordAreRejected() {
        let form = SignUpForm(name: "   ", email: "ada@example.com", password: "short")
        #expect(form.problems.count == 2)
    }

    // MARK: Layouts

    @Test func flowLayoutWrapsWhenARowIsFull() {
        let sizes = Array(repeating: CGSize(width: 40, height: 20), count: 3)
        let result = FlowLayout.arrange(sizes: sizes, maxWidth: 100, spacing: 10)
        // Two items fit in 100 points (40 + 10 + 40); the third starts a new row.
        #expect(result.origins == [CGPoint(x: 0, y: 0), CGPoint(x: 50, y: 0), CGPoint(x: 0, y: 30)])
        #expect(result.size == CGSize(width: 90, height: 50))
    }

    @Test func flowLayoutPlacesAnOversizedItemOnItsOwnRow() {
        let sizes = [CGSize(width: 150, height: 20), CGSize(width: 30, height: 20)]
        let result = FlowLayout.arrange(sizes: sizes, maxWidth: 100, spacing: 8)
        #expect(result.origins == [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 28)])
        #expect(result.size == CGSize(width: 150, height: 48))
    }

    @Test func flowLayoutWithNoItemsHasZeroSize() {
        let result = FlowLayout.arrange(sizes: [], maxWidth: 100, spacing: 8)
        #expect(result.origins.isEmpty)
        #expect(result.size == .zero)
    }

    // MARK: Drawing

    @Test func starHasTwoVerticesPerPointStartingAtTheTop() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let vertices = StarShape.vertices(points: 5, innerRatio: 0.5, in: rect)
        #expect(vertices.count == 10)
        #expect(abs(vertices[0].x - 50) < 0.001)
        #expect(abs(vertices[0].y - 0) < 0.001)
    }

    @Test func starWithFewerThanTwoPointsIsEmpty() {
        #expect(StarShape.vertices(points: 1, innerRatio: 0.5, in: CGRect(x: 0, y: 0, width: 10, height: 10)).isEmpty)
    }

    // MARK: Lists & grids

    @Test func sampleProduceHasUniqueIDs() {
        let ids = Produce.samples.map(\.id)
        #expect(Set(ids).count == ids.count)
    }
}
