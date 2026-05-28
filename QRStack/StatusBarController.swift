import AppKit
import SwiftUI

/// Owns the menu-bar status item and the popover that shows the QR generator.
///
/// Replaces SwiftUI's `MenuBarExtra(.window)` because that style auto-dismisses
/// when the user switches focus to another app — which breaks drag-and-drop
/// from sources like Safari's address bar (the popover closes the moment you
/// click into Safari to grab the drag). Wrapping `MenuBarContentView` in an
/// `NSPopover` with `.semitransient` behavior keeps the popover open across
/// app activation changes; it only closes when the user clicks outside the
/// popover area or hits the menu bar icon again.
///
/// Pairs nicely with the same surface needed for future drag-out QR images
/// (v0.3) and a configurable global hotkey (v0.5). Same pattern ClipStack
/// uses since its v0.5 refactor.
@MainActor
final class StatusBarController {
    private let statusItem: NSStatusItem
    private let popover: NSPopover

    init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.popover = NSPopover()

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "qrcode", accessibilityDescription: "QRStack")
            button.imagePosition = .imageOnly
            button.target = self
            button.action = #selector(togglePopover(_:))
        }

        popover.behavior = .semitransient  // stays open across app activation; closes on click-outside
        popover.animates = true
        popover.contentViewController = NSHostingController(rootView: MenuBarContentView())
    }

    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            showPopover()
        }
    }

    func showPopover() {
        guard let button = statusItem.button else { return }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        // Bring the app to the front so the popover can receive key events on first open.
        NSApp.activate(ignoringOtherApps: true)
    }
}
