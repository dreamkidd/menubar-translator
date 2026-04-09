import SwiftUI

struct SettingsView: View {
    @ObservedObject var appModel: AppModel

    var body: some View {
        Form {
            Section("Translation") {
                Picker("Default Direction", selection: $appModel.currentDirection) {
                    ForEach(LanguageDirection.allCases) { direction in
                        Text(direction.displayName).tag(direction)
                    }
                }
            }

            Section("Model") {
                LabeledContent("Status", value: appModel.modelManager.status.description)
                Text("Model download and lifecycle management will land after the first usable shell is stable.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("MVP Notes") {
                Text("Week 1 focuses on menu bar input, global shortcut triggering, clipboard fallback, and floating results.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}
