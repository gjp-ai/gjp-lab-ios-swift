import SwiftUI

/// A custom `Layout` that places subviews left to right and wraps to a new row when the width runs out,
/// like words in a paragraph.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        Self.arrange(sizes: sizes(of: subviews), maxWidth: proposal.width ?? .infinity, spacing: spacing).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let origins = Self.arrange(sizes: sizes(of: subviews), maxWidth: bounds.width, spacing: spacing).origins
        for (subview, origin) in zip(subviews, origins) {
            subview.place(at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y), proposal: .unspecified)
        }
    }

    private func sizes(of subviews: Subviews) -> [CGSize] {
        subviews.map { $0.sizeThatFits(.unspecified) }
    }

    /// The position of each item and the total size. Kept free of SwiftUI types so unit tests can call it.
    static func arrange(sizes: [CGSize], maxWidth: CGFloat, spacing: CGFloat) -> (origins: [CGPoint], size: CGSize) {
        var origins: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widest: CGFloat = 0

        for size in sizes {
            // Start a new row unless this is the first item in the row (an item wider than the row still gets placed).
            if x > 0, x + size.width > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            origins.append(CGPoint(x: x, y: y))
            widest = max(widest, x + size.width)
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return (origins, CGSize(width: widest, height: y + rowHeight))
    }
}
