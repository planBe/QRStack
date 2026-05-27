import AppKit
import SwiftUI

struct MenuBarContentView: View {
    @State private var inputText: String = ""
    @State private var copiedFlash: Bool = false

    private let popoverWidth: CGFloat = 320
    private let qrSize: CGFloat = 240

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header

            inputField

            Button(action: pasteFromClipboard) {
                Label("Use Clipboard Text", systemImage: "doc.on.clipboard")
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.regular)

            Divider()

            qrPreview

            Button(action: copyQRImage) {
                Label(copiedFlash ? "Copied" : "Copy QR Image",
                      systemImage: copiedFlash ? "checkmark" : "square.on.square")
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .disabled(currentImage == nil)
            .keyboardShortcut("c", modifiers: [.command])

            Divider()

            Button("Quit qrStack") { NSApp.terminate(nil) }
                .keyboardShortcut("q", modifiers: [.command])
                .controlSize(.small)
        }
        .padding(14)
        .frame(width: popoverWidth)
    }

    // MARK: - Subviews

    private var header: some View {
        HStack(spacing: 6) {
            Image(systemName: "qrcode")
                .font(.system(size: 14, weight: .semibold))
            Text("qrStack")
                .font(.system(size: 13, weight: .semibold))
            Spacer()
        }
    }

    private var inputField: some View {
        TextEditor(text: $inputText)
            .font(.system(size: 12, design: .monospaced))
            .frame(height: 60)
            .padding(6)
            .background(Color(nsColor: .textBackgroundColor))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    @ViewBuilder
    private var qrPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: qrSize, height: qrSize)

            if let image = currentImage {
                Image(nsImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: qrSize - 16, height: qrSize - 16)
            } else {
                Text("Type or paste text above")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
        )
    }

    // MARK: - State

    private var currentImage: NSImage? {
        QRGenerator.makeImage(from: inputText, pixelSize: 512)
    }

    // MARK: - Actions

    private func pasteFromClipboard() {
        if let text = NSPasteboard.general.string(forType: .string) {
            inputText = text
        }
    }

    private func copyQRImage() {
        guard let image = currentImage,
              let png = QRGenerator.pngData(from: image) else { return }
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setData(png, forType: .png)
        flashCopied()
    }

    private func flashCopied() {
        copiedFlash = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            copiedFlash = false
        }
    }
}
