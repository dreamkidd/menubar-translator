import SwiftUI

struct FloatingResultPanelView: View {
    let result: TranslationResult
    let onCopy: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Translation")
                    .font(.headline)
                Spacer()
                Button("Close", action: onClose)
                    .buttonStyle(.borderless)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Source")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(result.sourceText)
                    .font(.body)
                    .textSelection(.enabled)
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("Result")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(result.translatedText)
                    .font(.body)
                    .textSelection(.enabled)
            }

            HStack {
                Spacer()
                Button("Copy", action: onCopy)
                    .keyboardShortcut("c", modifiers: [.command])
            }
        }
        .padding(16)
        .frame(width: 420)
    }
}
