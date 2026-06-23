import AppKit

let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "weimingzhou_cover_recommend_base_20260623.png"
let outputPath = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "weimingzhou_cover_recommend_title_20260623.png"
let thumbPath = CommandLine.arguments.count > 3 ? CommandLine.arguments[3] : "weimingzhou_cover_recommend_thumb_20260623.png"

guard let source = NSImage(contentsOfFile: inputPath) else {
    fatalError("Cannot open input image: \(inputPath)")
}

func writePNG(_ image: NSImage, to path: String) {
    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let png = bitmap.representation(using: .png, properties: [:]) else {
        fatalError("Cannot encode output image: \(path)")
    }
    try! png.write(to: URL(fileURLWithPath: path))
}

func coverRect(sourceSize: NSSize, targetSize: NSSize) -> NSRect {
    let sourceRatio = sourceSize.width / sourceSize.height
    let targetRatio = targetSize.width / targetSize.height
    let drawSize: NSSize

    if sourceRatio > targetRatio {
        drawSize = NSSize(width: targetSize.height * sourceRatio, height: targetSize.height)
    } else {
        drawSize = NSSize(width: targetSize.width, height: targetSize.width / sourceRatio)
    }

    return NSRect(
        x: (targetSize.width - drawSize.width) / 2,
        y: (targetSize.height - drawSize.height) / 2,
        width: drawSize.width,
        height: drawSize.height
    )
}

func paragraph(_ alignment: NSTextAlignment) -> NSMutableParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.alignment = alignment
    return style
}

func titleFont(size: CGFloat) -> NSFont {
    return NSFont(name: "PingFangSC-Semibold", size: size)
        ?? NSFont(name: "HiraginoSansGB-W6", size: size)
        ?? NSFont(name: "STHeitiSC-Medium", size: size)
        ?? NSFont.boldSystemFont(ofSize: size)
}

func drawText(_ text: String, in rect: NSRect, font: NSFont, fill: NSColor, stroke: NSColor, strokeWidth: CGFloat, shadow: NSShadow?, kern: CGFloat) {
    var attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: fill,
        .paragraphStyle: paragraph(.center),
        .strokeColor: stroke,
        .strokeWidth: -strokeWidth,
        .kern: kern
    ]
    if let shadow {
        attrs[.shadow] = shadow
    }
    NSString(string: text).draw(in: rect, withAttributes: attrs)
}

func drawOverlay(on canvas: NSSize) {
    let titleBand = NSGradient(colors: [
        NSColor.black.withAlphaComponent(0.00),
        NSColor.black.withAlphaComponent(0.82),
        NSColor.black.withAlphaComponent(0.60),
        NSColor.black.withAlphaComponent(0.00)
    ])!
    titleBand.draw(
        in: NSRect(x: 0, y: canvas.height * 0.590, width: canvas.width, height: canvas.height * 0.205),
        angle: 90
    )

    let redGlow = NSGradient(colors: [
        NSColor(red: 0.95, green: 0.02, blue: 0.00, alpha: 0.38),
        NSColor(red: 0.50, green: 0.00, blue: 0.00, alpha: 0.16),
        NSColor.clear
    ])!
    redGlow.draw(
        in: NSRect(x: canvas.width * 0.15, y: canvas.height * 0.592, width: canvas.width * 0.70, height: canvas.height * 0.155),
        relativeCenterPosition: .zero
    )

    let titleShadow = NSShadow()
    titleShadow.shadowColor = NSColor.black.withAlphaComponent(0.98)
    titleShadow.shadowBlurRadius = canvas.width * 0.030
    titleShadow.shadowOffset = NSSize(width: 0, height: -canvas.height * 0.006)

    let titleRect = NSRect(
        x: canvas.width * 0.075,
        y: canvas.height * 0.635,
        width: canvas.width * 0.85,
        height: canvas.height * 0.128
    )

    drawText(
        "未名舟",
        in: titleRect,
        font: titleFont(size: 188),
        fill: NSColor(red: 1.00, green: 0.88, blue: 0.44, alpha: 1.0),
        stroke: NSColor(red: 0.025, green: 0.012, blue: 0.006, alpha: 1.0),
        strokeWidth: 8,
        shadow: titleShadow,
        kern: 8
    )

    drawText(
        "未名舟",
        in: titleRect.offsetBy(dx: 0, dy: 4),
        font: titleFont(size: 188),
        fill: NSColor(red: 1.00, green: 0.98, blue: 0.74, alpha: 0.55),
        stroke: .clear,
        strokeWidth: 0,
        shadow: nil,
        kern: 8
    )

    let rule = NSBezierPath()
    rule.move(to: CGPoint(x: canvas.width * 0.245, y: canvas.height * 0.630))
    rule.line(to: CGPoint(x: canvas.width * 0.755, y: canvas.height * 0.630))
    rule.lineCapStyle = .round
    rule.lineWidth = 5
    NSColor(red: 0.95, green: 0.05, blue: 0.02, alpha: 0.72).setStroke()
    rule.stroke()
}

func render(size: NSSize, drawTitle: Bool) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()

    NSColor.black.setFill()
    NSRect(origin: .zero, size: size).fill()

    if let ctx = NSGraphicsContext.current {
        ctx.imageInterpolation = .high
    }

    source.draw(in: coverRect(sourceSize: source.size, targetSize: size), from: .zero, operation: .copy, fraction: 1.0)
    if drawTitle {
        drawOverlay(on: size)
    }

    image.unlockFocus()
    return image
}

let final = render(size: NSSize(width: 1080, height: 1440), drawTitle: true)
writePNG(final, to: outputPath)

let thumb = NSImage(size: NSSize(width: 180, height: 240))
thumb.lockFocus()
if let ctx = NSGraphicsContext.current {
    ctx.imageInterpolation = .high
}
final.draw(in: NSRect(x: 0, y: 0, width: 180, height: 240), from: .zero, operation: .copy, fraction: 1.0)
thumb.unlockFocus()
writePNG(thumb, to: thumbPath)

print(outputPath)
print(thumbPath)
