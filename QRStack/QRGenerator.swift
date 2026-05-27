import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

enum QRGenerator {
    static func makeImage(from text: String, pixelSize: CGFloat = 512) -> NSImage? {
        guard let data = text.data(using: .utf8), !text.isEmpty else { return nil }

        let filter = CIFilter.qrCodeGenerator()
        filter.message = data
        filter.correctionLevel = "M"

        guard let ciImage = filter.outputImage else { return nil }

        let scale = pixelSize / ciImage.extent.width
        let scaled = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }

        return NSImage(cgImage: cgImage, size: NSSize(width: pixelSize, height: pixelSize))
    }

    static func pngData(from nsImage: NSImage) -> Data? {
        guard let tiff = nsImage.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiff) else { return nil }
        return rep.representation(using: .png, properties: [:])
    }
}
