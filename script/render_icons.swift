import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

func drawIcon(size: Int) throws -> CGImage {
  let scale = CGFloat(size) / 512.0
  let colorSpace = CGColorSpaceCreateDeviceRGB()

  guard
    let context = CGContext(
      data: nil,
      width: size,
      height: size,
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: colorSpace,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )
  else {
    throw NSError(domain: "TPSLIcon", code: 1)
  }

  context.scaleBy(x: scale, y: scale)
  context.translateBy(x: 0, y: 512)
  context.scaleBy(x: 1, y: -1)

  let bounds = CGRect(x: 0, y: 0, width: 512, height: 512)
  context.setFillColor(CGColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 1))
  context.addPath(CGPath(roundedRect: bounds, cornerWidth: 116, cornerHeight: 116, transform: nil))
  context.fillPath()

  func stroke(_ points: [CGPoint], color: CGColor) {
    context.setStrokeColor(color)
    context.setLineWidth(38)
    context.setLineCap(.round)
    context.setLineJoin(.round)
    context.beginPath()
    context.move(to: points[0])
    for point in points.dropFirst() {
      context.addLine(to: point)
    }
    context.strokePath()
  }

  stroke(
    [CGPoint(x: 148, y: 256), CGPoint(x: 364, y: 256)],
    color: CGColor(red: 248 / 255, green: 250 / 255, blue: 252 / 255, alpha: 1)
  )
  stroke(
    [CGPoint(x: 148, y: 182), CGPoint(x: 276, y: 182), CGPoint(x: 364, y: 256)],
    color: CGColor(red: 34 / 255, green: 197 / 255, blue: 94 / 255, alpha: 1)
  )
  stroke(
    [CGPoint(x: 148, y: 330), CGPoint(x: 276, y: 330), CGPoint(x: 364, y: 256)],
    color: CGColor(red: 239 / 255, green: 68 / 255, blue: 68 / 255, alpha: 1)
  )

  guard let image = context.makeImage() else {
    throw NSError(domain: "TPSLIcon", code: 2)
  }

  return image
}

func writePNG(_ image: CGImage, to url: URL) throws {
  guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
    throw NSError(domain: "TPSLIcon", code: 3)
  }

  CGImageDestinationAddImage(destination, image, nil)
  if !CGImageDestinationFinalize(destination) {
    throw NSError(domain: "TPSLIcon", code: 4)
  }
}

try writePNG(drawIcon(size: 192), to: root.appendingPathComponent("icon-192.png"))
try writePNG(drawIcon(size: 512), to: root.appendingPathComponent("icon-512.png"))
