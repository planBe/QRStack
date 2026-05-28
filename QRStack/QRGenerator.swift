import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

/// QR error-correction levels per ISO/IEC 18004. Higher levels embed more
/// redundancy (denser modules) but tolerate more damage / occlusion before
/// failing to scan.
enum QRCorrectionLevel: String, CaseIterable, Identifiable {
    case low = "L"      // ~7% recovery
    case medium = "M"   // ~15% recovery — sensible default for clean digital scans
    case quartile = "Q" // ~25% recovery
    case high = "H"     // ~30% recovery — picks for print contexts where ink fade matters

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .low: return "L (7%)"
        case .medium: return "M (15%)"
        case .quartile: return "Q (25%)"
        case .high: return "H (30%)"
        }
    }
}

/// Pixel dimensions of the generated PNG. Display preview always renders the
/// generator output into the popover's fixed-size box via scaledToFit; the
/// size picker only affects what lands on the clipboard when Copy QR Image
/// is pressed.
enum QRSize: Int, CaseIterable, Identifiable {
    case small = 256
    case medium = 512
    case large = 1024
    case xlarge = 2048

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .small: return "Small (256)"
        case .medium: return "Medium (512)"
        case .large: return "Large (1024)"
        case .xlarge: return "Huge (2048)"
        }
    }
}

enum QRGenerator {
    static func makeImage(from text: String,
                          pixelSize: CGFloat = 512,
                          correctionLevel: QRCorrectionLevel = .medium) -> NSImage? {
        guard let data = text.data(using: .utf8), !text.isEmpty else { return nil }

        let filter = CIFilter.qrCodeGenerator()
        filter.message = data
        filter.correctionLevel = correctionLevel.rawValue

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
