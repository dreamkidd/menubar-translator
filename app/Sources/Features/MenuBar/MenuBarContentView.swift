import AppKit
import SwiftUI

struct MenuBarContentView: View {
    @ObservedObject var appModel: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            inputArea
            actionRow
            resultArea
            footerRow
        }
        .padding(14)
    }

    private var header: some View {
        HStack {
            Text("Menubar Translator")
                .font(.headline)

            Spacer()

            Picker("Direction", selection: $appModel.currentDirection) {
                ForEach(LanguageDirection.allCases) { direction in
                    Text(direction.displayName).tag(direction)
                }
            }
            .labelsHidden()
            .frame(width: 170)
        }
    }

    private var inputArea: some View {
        TextEditor(text: $appModel.manualInput)
            .font(.body)
            .frame(minHeight: 92)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
            )
    }

    private var actionRow: some View {
        HStack(spacing: 8) {
            Button("Translate") {
                appModel.translateManualInput()
            }
            .keyboardShortcut(.return, modifiers: [.command])

            Button("Clipboard") {
                appModel.translateClipboard()
            }

            Spacer()

            if appModel.isTranslating {
                ProgressView()
                    .controlSize(.small)
            }
        }
    }

    @ViewBuilder
    private var resultArea: some View {
        if let result = appModel.latestResult {
            VStack(alignment: .leading, spacing: 8) {
                Text("Translation")
                    .font(.subheadline.weight(.semibold))

                Text(result.translatedText)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(Color.secondary.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        } else if let errorMessage = appModel.lastErrorMessage {
            Text(errorMessage)
                .font(.footnote)
                .foregroundStyle(.red)
        } else {
            Text("Paste or type text, then translate.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private var footerRow: some View {
        HStack {
            Button("Copy Result") {
                appModel.copyLatestTranslation()
            }
            .disabled(appModel.latestResult == nil)

            Spacer()

            Button("Settings") {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
}
