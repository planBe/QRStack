# SETUP.md — qrStack

How to build qrStack from source.

## Prerequisites

- macOS 13.0 (Ventura) or later
- Xcode 16+ (Command Line Tools required: `xcode-select --install`)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`

## Build

```sh
git clone https://github.com/planBe/QRStack.git
cd QRStack
xcodegen generate
open QRStack.xcodeproj
```

Then ⌘R in Xcode to build and launch.

## Project structure

- `project.yml` — canonical XcodeGen spec. `QRStack.xcodeproj` is generated from
  this; never edit the `.xcodeproj` directly. Regenerate with `xcodegen generate`
  after any spec change.
- `QRStack/` — Swift source
  - `QRStackApp.swift` — `@main` entry, `MenuBarExtra` Scene
  - `QRGenerator.swift` — `CIQRCodeGenerator` wrapper, returns `NSImage` + PNG `Data`
  - `MenuBarContentView.swift` — popover UI (text input, preview, copy buttons)
  - `Assets.xcassets/` — `AppIcon` + `AccentColor`
  - `QRStack.entitlements` — App Sandbox enabled

## Build settings

Locked in `project.yml`:

- Bundle ID `com.planbecreative.QRStack`
- Bundle Display Name `qrStack` (lowercase brand)
- `LSUIElement = YES` (menu bar agent; no Dock icon)
- macOS 13.0 minimum
- App Sandbox + Hardened Runtime
- Universal binary (arm64 + x86_64)

## Troubleshooting

**`xcodebuild` fails with "no schemes":** regenerate with `xcodegen generate`.

**Code signing prompts for Team:** open `QRStack.xcodeproj` in Xcode →
Signing & Capabilities → Team dropdown → pick your Apple Developer account
(or "None (Sign to Run Locally)" for local builds).

**Menu bar icon doesn't appear:** macOS may hide menu bar items when the bar
is crowded. Use Ice (free) or Bartender to manage visibility.

## License

MIT. See [LICENSE](LICENSE).
