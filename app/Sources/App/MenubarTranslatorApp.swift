import SwiftUI

@main
struct MenubarTranslatorApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        MenuBarExtra("MenubarTranslator", systemImage: "globe") {
            MenuBarContentView(appModel: appModel)
                .frame(width: 360)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView(appModel: appModel)
                .frame(width: 420, height: 320)
        }
    }
}
