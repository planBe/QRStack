# qrStack

A lean macOS menu bar QR code generator. Type or paste text, get a QR image,
copy it to the clipboard. That's it.

Part of the **Stack** family of free macOS utilities by Michael Wild — sibling
to [clipStack](https://github.com/planBe/ClipStack) and
[timeStack](https://github.com/planBe/TimeStack).

## Status

**v0.1 — early development.** Working menu bar app with live QR preview and
copy-to-clipboard. Hotkey support, size options, error-correction-level toggle,
and history are planned for later versions.

## Features (v0.1)

- Lives in the menu bar; no Dock icon
- Live QR preview as you type
- One-click pull text from the system clipboard
- One-click copy the QR image (PNG) to the clipboard
- Pure SwiftUI + AppKit + CoreImage; zero third-party dependencies
- App Sandbox + Hardened Runtime enabled (App Store ready)

## Privacy

qrStack does not collect, transmit, or store any data. The QR generation
happens entirely on-device via Apple's `CIQRCodeGenerator` filter. No network
calls. See [PRIVACY.md](PRIVACY.md) for the full statement.

## Requirements

- macOS 13.0 (Ventura) or later
- Universal binary: Apple Silicon and Intel

## Building from source

Requires Xcode 16+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen)
(install via `brew install xcodegen`). See [SETUP.md](SETUP.md).

```sh
git clone https://github.com/planBe/QRStack.git
cd QRStack
xcodegen generate
open QRStack.xcodeproj
```

Then ⌘R in Xcode.

## Roadmap

- [x] v0.1 — live menu bar QR generator with copy-to-clipboard
- [ ] v0.2 — size options, error-correction-level toggle
- [ ] v0.3 — drag-out QR image to other apps
- [ ] v0.4 — recent history
- [ ] v0.5 — configurable global hotkey
- [ ] v1.0 — App Store + notarized GitHub Release

## License

MIT. See [LICENSE](LICENSE).

---

Made by Michael Wild — plan Be creative
