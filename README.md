# qrStack

A lean macOS menu bar QR code generator. Type or paste text, get a QR image,
copy it to the clipboard. That's it.

Part of the **Stack** family of free macOS utilities by Michael Wild — sibling
to [clipStack](https://github.com/planBe/ClipStack) and
[timeStack](https://github.com/planBe/TimeStack).

## Status

**v1.0.** Free menu bar QR code generator for macOS — live QR preview,
drag-and-drop URLs/text in, drag-out PNG to other apps, recent history,
size + error-correction-level options, copy-to-clipboard, and a global
hotkey (⌥⇧⌘R) to pop the menu from anywhere. Configurable hotkey
binding is planned for a post-1.0 release.

## Features

- Lives in the menu bar; no Dock icon
- Live QR preview as you type
- **Drag-and-drop URLs or text** straight into the input field (drag from
  Safari's address bar, the Finder URL field, or any text source)
- **Drag the QR image out** to Pages, Mail, Keynote, Finder, or any image
  target — the PNG drops at your chosen Size setting
- **Recent history** — last 10 generated inputs persist across launches;
  click to re-populate
- **Size picker** — Small / Medium / Large / Huge (256 / 512 / 1024 / 2048 px)
  for the copied PNG
- **Error-correction-level toggle** — L (7%) / M (15%, default) / Q (25%) /
  H (30%) per ISO/IEC 18004
- **Global hotkey ⌥⇧⌘R** opens the popover from any app, even when qrStack
  doesn't have focus
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
- [x] v0.2 — drag-and-drop URLs/text, recent history (10 max, persisted), size
  options (256/512/1024/2048), error-correction-level toggle (L/M/Q/H)
- [x] v0.3 — drag-out QR image to other apps (NSItemProvider write side)
- [x] v0.4 — global hotkey ⌥⇧⌘R to open the popover from anywhere (Carbon
  RegisterEventHotKey; sandbox-clean, no Accessibility permission required)
- [x] v1.0 — first Mac App Store release (consolidates v0.1–v0.4)
- [ ] v1.1 — configurable hotkey binding (Settings UI)
- [ ] v1.2 — decode mode: drop a QR image, get the embedded text back

## License

MIT. See [LICENSE](LICENSE).

---

Made by Michael Wild — plan Be creative
