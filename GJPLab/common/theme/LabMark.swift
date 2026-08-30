import SwiftUI

struct LabMark: View {
    let color: Color

    var body: some View {
        Canvas { context, size in
            let scale = min(size.width, size.height) / 108
            let offsetX = (size.width - 108 * scale) / 2
            let offsetY = (size.height - 108 * scale) / 2
            let transform = CGAffineTransform(translationX: offsetX, y: offsetY)
                .scaledBy(x: scale, y: scale)

            var field = Path(ellipseIn: CGRect(x: 20, y: 20, width: 68, height: 68))
            var flask = Path()
            flask.move(to: CGPoint(x: 46, y: 32))
            flask.addLine(to: CGPoint(x: 62, y: 32))
            flask.addLine(to: CGPoint(x: 62, y: 46))
            flask.addLine(to: CGPoint(x: 74, y: 68))
            flask.addCurve(
                to: CGPoint(x: 66, y: 82),
                control1: CGPoint(x: 78, y: 76),
                control2: CGPoint(x: 73, y: 82)
            )
            flask.addLine(to: CGPoint(x: 42, y: 82))
            flask.addCurve(
                to: CGPoint(x: 34, y: 68),
                control1: CGPoint(x: 35, y: 82),
                control2: CGPoint(x: 30, y: 76)
            )
            flask.addLine(to: CGPoint(x: 46, y: 46))
            flask.closeSubpath()
            field.addPath(flask)

            var liquid = Path()
            liquid.move(to: CGPoint(x: 39, y: 65))
            liquid.addCurve(
                to: CGPoint(x: 69, y: 64),
                control1: CGPoint(x: 47, y: 61),
                control2: CGPoint(x: 54, y: 69)
            )
            liquid.addLine(to: CGPoint(x: 73, y: 71))
            liquid.addCurve(
                to: CGPoint(x: 66, y: 78),
                control1: CGPoint(x: 75, y: 75),
                control2: CGPoint(x: 72, y: 78)
            )
            liquid.addLine(to: CGPoint(x: 42, y: 78))
            liquid.addCurve(
                to: CGPoint(x: 37, y: 71),
                control1: CGPoint(x: 38, y: 78),
                control2: CGPoint(x: 35, y: 75)
            )
            liquid.closeSubpath()

            context.fill(field.applying(transform), with: .color(color), style: FillStyle(eoFill: true))
            context.fill(liquid.applying(transform), with: .color(color))
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityHidden(true)
    }
}

#Preview("Lab mark") {
    HStack(spacing: 24) {
        LabMark(color: .white)
            .frame(width: 108, height: 108)
            .background(.black)
        LabMark(color: .black)
            .frame(width: 108, height: 108)
            .background(.white)
    }
    .padding()
}
