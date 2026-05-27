import SwiftUI

@main
struct QRStackApp: App {
    var body: some Scene {
        MenuBarExtra("QRStack", systemImage: "qrcode") {
            MenuBarContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
