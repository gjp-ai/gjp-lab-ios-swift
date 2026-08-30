#!/usr/bin/env swift

import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct RGB {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    init(_ value: UInt32) {
        red = CGFloat((value >> 16) & 0xFF) / 255
        green = CGFloat((value >> 8) & 0xFF) / 255
        blue = CGFloat(value & 0xFF) / 255
    }

    var color: CGColor { CGColor(red: red, green: green, blue: blue, alpha: 1) }
}

struct AppIconVariant {
    let filename: String
    let background: RGB
    let mark: RGB
}

let variants = [
    AppIconVariant(filename: "AppIcon.png", background: RGB(0x000000), mark: RGB(0xFFFFFF)),
    AppIconVariant(filename: "AppIcon-Dark.png", background: RGB(0x151515), mark: RGB(0xFFFFFF)),
    AppIconVariant(filename: "AppIcon-Tinted.png", background: RGB(0x262626), mark: RGB(0xF2F2F2))
]

let outputDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent("GJPLab/Assets.xcassets/AppIcon.appiconset", isDirectory: true)

func render(_ variant: AppIconVariant) throws {
    let pixelSize = 1024
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let context = CGContext(
        data: nil,
        width: pixelSize,
        height: pixelSize,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    ) else {
        throw CocoaError(.fileWriteUnknown)
    }

    context.setFillColor(variant.background.color)
    context.fill(CGRect(x: 0, y: 0, width: pixelSize, height: pixelSize))

    context.saveGState()
    context.translateBy(x: 0, y: CGFloat(pixelSize))
    context.scaleBy(x: CGFloat(pixelSize) / 108, y: -CGFloat(pixelSize) / 108)
    context.setFillColor(variant.mark.color)

    let field = CGMutablePath()
    field.addEllipse(in: CGRect(x: 20, y: 20, width: 68, height: 68))

    let flask = CGMutablePath()
    flask.move(to: CGPoint(x: 46, y: 32))
    flask.addLine(to: CGPoint(x: 62, y: 32))
    flask.addLine(to: CGPoint(x: 62, y: 46))
    flask.addLine(to: CGPoint(x: 74, y: 68))
    flask.addCurve(to: CGPoint(x: 66, y: 82), control1: CGPoint(x: 78, y: 76), control2: CGPoint(x: 73, y: 82))
    flask.addLine(to: CGPoint(x: 42, y: 82))
    flask.addCurve(to: CGPoint(x: 34, y: 68), control1: CGPoint(x: 35, y: 82), control2: CGPoint(x: 30, y: 76))
    flask.addLine(to: CGPoint(x: 46, y: 46))
    flask.closeSubpath()
    field.addPath(flask)

    context.addPath(field)
    context.drawPath(using: .eoFill)

    let liquid = CGMutablePath()
    liquid.move(to: CGPoint(x: 39, y: 65))
    liquid.addCurve(to: CGPoint(x: 69, y: 64), control1: CGPoint(x: 47, y: 61), control2: CGPoint(x: 54, y: 69))
    liquid.addLine(to: CGPoint(x: 73, y: 71))
    liquid.addCurve(to: CGPoint(x: 66, y: 78), control1: CGPoint(x: 75, y: 75), control2: CGPoint(x: 72, y: 78))
    liquid.addLine(to: CGPoint(x: 42, y: 78))
    liquid.addCurve(to: CGPoint(x: 37, y: 71), control1: CGPoint(x: 38, y: 78), control2: CGPoint(x: 35, y: 75))
    liquid.closeSubpath()
    context.addPath(liquid)
    context.fillPath()
    context.restoreGState()

    guard let image = context.makeImage() else {
        throw CocoaError(.fileWriteUnknown)
    }

    let outputURL = outputDirectory.appendingPathComponent(variant.filename)
    guard let destination = CGImageDestinationCreateWithURL(
        outputURL as CFURL,
        UTType.png.identifier as CFString,
        1,
        nil
    ) else {
        throw CocoaError(.fileWriteUnknown)
    }
    CGImageDestinationAddImage(destination, image, nil)
    guard CGImageDestinationFinalize(destination) else {
        throw CocoaError(.fileWriteUnknown)
    }
    print("Rendered \(outputURL.path)")
}

for variant in variants {
    try render(variant)
}
