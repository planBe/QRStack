# Privacy Policy — qrStack

**Last updated:** 2026-05-27

qrStack is a local-only macOS menu bar QR code generator. It does not collect,
transmit, store, or share any user data.

## What qrStack does with your input

When you type or paste text into qrStack's popover, the text is encoded into
a QR code image using Apple's `CIQRCodeGenerator` Core Image filter,
entirely on your Mac. Nothing leaves your device.

The text you type is held in memory while the popover is open and discarded
when the app quits. qrStack does not write your input to disk.

## Network

qrStack makes no network requests of any kind. There is no telemetry,
analytics, crash reporting, ad SDK, or remote configuration.

## Clipboard

When you click **Use Clipboard Text**, qrStack reads the current system
clipboard contents (text only) and places them in the input field. When you
click **Copy QR Image**, qrStack writes the generated QR image (PNG format)
to the system clipboard. No other clipboard access occurs.

## App Sandbox

qrStack runs inside macOS's App Sandbox with the most restrictive default
profile — it can only access its own private container. It does not request
file system access, camera, microphone, contacts, calendar, location, or any
other privacy-protected resource.

## Open source

qrStack's full source code is available at
[github.com/planBe/QRStack](https://github.com/planBe/QRStack). Anyone can
audit the privacy claims above by reading the code.

## Contact

Questions: [github.com/planBe/QRStack/issues](https://github.com/planBe/QRStack/issues)

---

Made by Michael Wild — plan Be creative
