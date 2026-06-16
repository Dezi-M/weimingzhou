import AppKit

let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "weimingzhou_cover_base_v1.png"
let outputPath = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "weimingzhou_cover_title_v1.png"
let subtitle = CommandLine.arguments.count > 3 ? CommandLine.arguments[3] : "不替人命名，不删除债"

guard let source = NSImage(contentsOfFile: inputPath) else {
    fatalError("Cannot open input image: \(inputPath)")
}

let scale: CGFloat = 2.0
let canvas = NSSize(width: 1024 * scale, height: 1536 * scale)
let image = NSImage(size: canvas)

func paragraph(_ alignment: NSTextAlignment) -> NSMutableParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.alignment = alignment
    return style
}

func drawText(_ text: String, in rect: NSRect, font: NSFont, fill: NSColor, stroke: NSColor, strokeWidth: CGFloat, shadow: NSShadow?, alignment: NSTextAlignment = .center) {
    var attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: fill,
        .paragraphStyle: paragraph(alignment),
        .strokeColor: stroke,
        .strokeWidth: -strokeWidth,
        .kern: 7.0 * scale
    ]
    if let shadow {
        attrs[.shadow] = shadow
    }
    NSString(string: text).draw(in: rect, withAttributes: attrs)
}

image.lockFocus()

NSColor.black.setFill()
NSRect(origin: .zero, size: canvas).fill()
source.draw(in: NSRect(origin: .zero, size: canvas), from: .zero, operation: .sourceOver, fraction: 1.0)

let ctx = NSGraphicsContext.current!.cgContext
ctx.saveGState()
let topGradient = NSGradient(colors: [
    NSColor.black.withAlphaComponent(0.72),
    NSColor.black.withAlphaComponent(0.24),
    NSColor.black.withAlphaComponent(0.0)
])!
topGradient.draw(in: NSRect(x: 0, y: canvas.height * 0.58, width: canvas.width, height: canvas.height * 0.42), angle: -90)

ctx.restoreGState()

let titleShadow = NSShadow()
titleShadow.shadowColor = NSColor.black.withAlphaComponent(0.92)
titleShadow.shadowBlurRadius = 30 * scale
titleShadow.shadowOffset = NSSize(width: 0, height: -5 * scale)

let glowShadow = NSShadow()
glowShadow.shadowColor = NSColor(red: 0.95, green: 0.22, blue: 0.10, alpha: 0.58)
glowShadow.shadowBlurRadius = 18 * scale
glowShadow.shadowOffset = .zero

let titleFont = NSFont(name: "STHeitiSC-Medium", size: 178 * scale)
    ?? NSFont(name: "STHeiti", size: 178 * scale)
    ?? NSFont.boldSystemFont(ofSize: 178 * scale)
let subFont = NSFont(name: "HiraginoSans-W6", size: 42 * scale)
    ?? NSFont.boldSystemFont(ofSize: 42 * scale)
let titleRect = NSRect(x: 112 * scale, y: 1134 * scale, width: 800 * scale, height: 250 * scale)
drawText("未名舟", in: titleRect, font: titleFont, fill: NSColor(red: 1.0, green: 0.28, blue: 0.12, alpha: 0.16), stroke: NSColor(red: 0.96, green: 0.18, blue: 0.08, alpha: 0.50), strokeWidth: 1.2 * scale, shadow: glowShadow)
drawText("未名舟", in: titleRect, font: titleFont, fill: NSColor(red: 1.0, green: 0.90, blue: 0.62, alpha: 1), stroke: NSColor(red: 0.05, green: 0.03, blue: 0.02, alpha: 0.98), strokeWidth: 2.1 * scale, shadow: titleShadow)

let subtitleRect = NSRect(x: 206 * scale, y: 1098 * scale, width: 612 * scale, height: 62 * scale)
drawText(subtitle, in: subtitleRect, font: subFont, fill: NSColor(red: 0.92, green: 0.85, blue: 0.70, alpha: 0.98), stroke: NSColor.black.withAlphaComponent(0.70), strokeWidth: 3.0 * scale, shadow: titleShadow)

image.unlockFocus()

guard let tiff = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff),
      let png = bitmap.representation(using: .png, properties: [:]) else {
    fatalError("Cannot encode output image")
}

try png.write(to: URL(fileURLWithPath: outputPath))
print(outputPath)
