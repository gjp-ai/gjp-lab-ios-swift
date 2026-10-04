import SwiftUI

/// A star with a configurable number of points. `innerRatio` is animatable, so the star can morph smoothly
/// between spiky (small ratio) and round (ratio near 1).
struct StarShape: Shape {
    var points: Int
    var innerRatio: Double

    var animatableData: Double {
        get { innerRatio }
        set { innerRatio = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let vertices = Self.vertices(points: points, innerRatio: innerRatio, in: rect)
        var path = Path()
        guard let first = vertices.first else { return path }
        path.move(to: first)
        vertices.dropFirst().forEach { path.addLine(to: $0) }
        path.closeSubpath()
        return path
    }

    /// The corners of the star, alternating outer and inner, starting at the top. Unit tests call this directly.
    static func vertices(points: Int, innerRatio: Double, in rect: CGRect) -> [CGPoint] {
        guard points >= 2 else { return [] }
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * innerRatio
        let step = Double.pi / Double(points)

        return (0..<points * 2).map { index in
            let radius = index.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = Double(index) * step - .pi / 2
            return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
        }
    }
}
