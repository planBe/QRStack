import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct MenuBarContentView: View {
    @StateObject private var history = HistoryStore()
    @AppStorage("QRStack.size") private var sizeRaw: Int = QRSize.medium.rawValue
    @AppStorage("QRStack.correction") private var correctionRaw: String = QRCorrectionLevel.medium.rawValue

    @State private var inputText: String = ""
    @State private var copiedFlash: Bool = false
    @State private var isDropTargeted: Bool = false

    private let popoverWidth: CGFloat = 320
    private let qrSize: CGFloat = 240

    private var size: QRSize { QRSize(rawValue: sizeRaw) ?? .medium }
    private var correction: QRCorrectionLevel { QRCorrectionLevel(rawValue: correctionRaw) ?? .medium }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header

            inputField

            Button(action: pasteFromClipboard) {
                Label("Use Clipboard Text", systemImage: "doc.on.clipboard")
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.small)

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

            settingsSection

            if !history.items.isEmpty {
                Divider()
                historySection
            }

            Divider()

            Button("Quit qrStack") { NSApp.terminate(nil) }
                .keyboardShortcut("q", modifiers: [.command])
                .controlSize(.small)
        }
        .padding(14)
        .frame(width: popoverWidth)
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 6) {
            Image(systemName: "qrcode")
                .font(.system(size: 14, weight: .semibold))
            Text("qrStack")
                .font(.system(size: 13, weight: .semibold))
            Spacer()
        }
    }

    // MARK: - Input field

    private var inputField: some View {
        TextEditor(text: $inputText)
            .font(.system(size: 12, design: .monospaced))
            .frame(height: 60)
            .padding(6)
            .background(Color(nsColor: .textBackgroundColor))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isDropTargeted ? Color.accentColor : Color(nsColor: .separatorColor),
                            lineWidth: isDropTargeted ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .onDrop(of: [.url, .plainText, .utf8PlainText],
                    isTargeted: $isDropTargeted,
                    perform: handleDrop)
    }

    // MARK: - QR preview

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
                Text("Type, paste, or drop text above")
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

    // MARK: - Settings (size + correction level)

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Size")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                Spacer()
                Picker("", selection: $sizeRaw) {
                    ForEach(QRSize.allCases) { Text($0.displayName).tag($0.rawValue) }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .frame(width: 140)
            }
            HStack {
                Text("Correction")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                Spacer()
                Picker("", selection: $correctionRaw) {
                    ForEach(QRCorrectionLevel.allCases) { Text($0.displayName).tag($0.rawValue) }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .frame(width: 140)
            }
        }
    }

    // MARK: - Recent history

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("RECENT")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .tracking(0.6)
                Spacer()
                Button("Clear") { history.clear() }
                    .buttonStyle(.plain)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }

            ForEach(history.items, id: \.self) { item in
                Button(action: { inputText = item }) {
                    Text(item)
                        .font(.system(size: 11, design: .monospaced))
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 4)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - State

    private var currentImage: NSImage? {
        QRGenerator.makeImage(from: inputText,
                              pixelSize: CGFloat(size.rawValue),
                              correctionLevel: correction)
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
        history.add(inputText)
        flashCopied()
    }

    private func flashCopied() {
        copiedFlash = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            copiedFlash = false
        }
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }

        // Prefer URL representation (drops from Safari address bar etc.); fall
        // back to plain text. NSItemProvider's load APIs are async; the input
        // field updates on the main queue once the provider resolves.
        if provider.canLoadObject(ofClass: URL.self) {
            _ = provider.loadObject(ofClass: URL.self) { url, _ in
                guard let url else { return }
                DispatchQueue.main.async { self.inputText = url.absoluteString }
            }
            return true
        }
        if provider.canLoadObject(ofClass: NSString.self) {
            _ = provider.loadObject(ofClass: NSString.self) { string, _ in
                guard let s = string as? String else { return }
                DispatchQueue.main.async { self.inputText = s }
            }
            return true
        }
        return false
    }
}
