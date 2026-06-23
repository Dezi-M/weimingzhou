import AppKit
import CoreText

let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "weimingzhou_cover_recommend_base_20260623.png"
let outputPath = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "weimingzhou_cover_recommend_title_20260623.png"
let thumbPath = CommandLine.arguments.count > 3 ? CommandLine.arguments[3] : "weimingzhou_cover_recommend_thumb_20260623.png"

let fontPaths = [
    "/System/Library/AssetsV2/com_apple_MobileAsset_Font8/c745f84f5eb15b1f594d3769dc86146fccee61ff.asset/AssetData/WeibeiSC-Bold.otf",
    "/System/Library/AssetsV2/PreinstalledAssetsV2/InstallWithOs/com_apple_MobileAsset_Font7/ed859925cd6b258d132f031b110e194945a104b1.asset/AssetData/WeibeiSC-Bold.otf"
]

for path in fontPaths where FileManager.default.fileExists(atPath: path) {
    CTFontManagerRegisterFontsForURL(URL(fileURLWithPath: path) as CFURL, .process, nil)
}

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
    return NSFont(name: "WeibeiSC-Bold", size: size)
        ?? NSFont(name: "STSongti-SC-Black", size: size)
        ?? NSFont(name: "PingFangSC-Semibold", size: size)
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

func drawSunbreakGlow(on canvas: NSSize) {
    let center = CGPoint(x: canvas.width * 0.500, y: canvas.height * 0.710)
    let maxRadius = canvas.width * 0.390

    for step in stride(from: 10, through: 1, by: -1) {
        let progress = CGFloat(step) / 10.0
        let radius = maxRadius * progress
        let alpha = 0.030 * (1.0 - progress) + 0.010
        let rect = NSRect(
            x: center.x - radius,
            y: center.y - radius * 0.62,
            width: radius * 2.0,
            height: radius * 1.24
        )
        NSColor(red: 1.00, green: 0.78, blue: 0.20, alpha: alpha).setFill()
        NSBezierPath(ovalIn: rect).fill()
    }

    let rayColor = NSColor(red: 1.0, green: 0.90, blue: 0.45, alpha: 0.10)
    let rayWidth = canvas.width * 0.010
    let rays = [
        (CGPoint(x: canvas.width * 0.385, y: canvas.height * 0.695), CGPoint(x: canvas.width * 0.245, y: canvas.height * 0.815)),
        (CGPoint(x: canvas.width * 0.500, y: canvas.height * 0.725), CGPoint(x: canvas.width * 0.500, y: canvas.height * 0.855)),
        (CGPoint(x: canvas.width * 0.615, y: canvas.height * 0.695), CGPoint(x: canvas.width * 0.755, y: canvas.height * 0.815))
    ]

    for (start, end) in rays {
        let path = NSBezierPath()
        path.move(to: start)
        path.line(to: end)
        path.lineCapStyle = .round
        path.lineWidth = rayWidth
        rayColor.setStroke()
        path.stroke()
    }
}

func drawGoldCharacter(_ char: String, center: CGPoint, size: CGFloat, rotation: CGFloat, canvas: NSSize) {
    let rect = NSRect(
        x: center.x - size * 0.62,
        y: center.y - size * 0.60,
        width: size * 1.24,
        height: size * 1.38
    )

    NSGraphicsContext.saveGraphicsState()
    let transform = NSAffineTransform()
    transform.translateX(by: center.x, yBy: center.y)
    transform.rotate(byDegrees: rotation)
    transform.translateX(by: -center.x, yBy: -center.y)
    transform.concat()

    let emberGlow = NSShadow()
    emberGlow.shadowColor = NSColor(red: 1.00, green: 0.78, blue: 0.16, alpha: 0.60)
    emberGlow.shadowBlurRadius = canvas.width * 0.026
    emberGlow.shadowOffset = .zero

    let blackDrop = NSShadow()
    blackDrop.shadowColor = NSColor.black.withAlphaComponent(0.98)
    blackDrop.shadowBlurRadius = canvas.width * 0.018
    blackDrop.shadowOffset = NSSize(width: 0, height: -canvas.height * 0.005)

    drawText(
        char,
        in: rect.offsetBy(dx: 0, dy: -size * 0.035),
        font: titleFont(size: size),
        fill: NSColor(red: 0.020, green: 0.010, blue: 0.004, alpha: 0.96),
        stroke: NSColor.black.withAlphaComponent(0.98),
        strokeWidth: size * 0.064,
        shadow: blackDrop,
        kern: 0
    )

    drawText(
        char,
        in: rect,
        font: titleFont(size: size),
        fill: NSColor(red: 1.00, green: 0.97, blue: 0.48, alpha: 1.00),
        stroke: NSColor(red: 0.135, green: 0.060, blue: 0.010, alpha: 0.98),
        strokeWidth: size * 0.034,
        shadow: emberGlow,
        kern: 0
    )

    drawText(
        char,
        in: rect.offsetBy(dx: 0, dy: size * 0.035),
        font: titleFont(size: size),
        fill: NSColor(red: 1.00, green: 1.00, blue: 0.86, alpha: 0.62),
        stroke: .clear,
        strokeWidth: 0,
        shadow: nil,
        kern: 0
    )

    let slash = NSBezierPath()
    slash.move(to: CGPoint(x: rect.minX + rect.width * 0.26, y: rect.minY + rect.height * 0.62))
    slash.line(to: CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.minY + rect.height * 0.76))
    slash.lineWidth = max(1.5, size * 0.018)
    slash.lineCapStyle = .round
    NSColor(red: 1.0, green: 1.0, blue: 0.72, alpha: 0.32).setStroke()
    slash.stroke()

    NSGraphicsContext.restoreGraphicsState()
}

func drawFloatingTitle(on canvas: NSSize) {
    drawSunbreakGlow(on: canvas)

    let size = canvas.width * 0.188
    let chars = ["未", "名", "舟"]
    let centers = [
        CGPoint(x: canvas.width * 0.345, y: canvas.height * 0.692),
        CGPoint(x: canvas.width * 0.500, y: canvas.height * 0.742),
        CGPoint(x: canvas.width * 0.655, y: canvas.height * 0.692)
    ]
    let rotations: [CGFloat] = [0, 0, 0]

    for i in 0..<3 {
        drawGoldCharacter(chars[i], center: centers[i], size: size, rotation: rotations[i], canvas: canvas)
    }
}

func render(size: NSSize) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()

    NSColor.black.setFill()
    NSRect(origin: .zero, size: size).fill()

    if let ctx = NSGraphicsContext.current {
        ctx.imageInterpolation = .high
    }

    source.draw(in: coverRect(sourceSize: source.size, targetSize: size), from: .zero, operation: .copy, fraction: 1.0)
    drawFloatingTitle(on: size)

    image.unlockFocus()
    return image
}

let final = render(size: NSSize(width: 1080, height: 1440))
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
