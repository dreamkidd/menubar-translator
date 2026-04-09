import SwiftUI

struct FloatingResultPanelView: View {
    let content: FloatingPanelContent
    let onCopy: (() -> Void)?
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(headerTitle)
                    .font(.headline)
                Spacer()
                Button("Close", action: onClose)
                    .buttonStyle(.borderless)
            }

            panelBody

            if let onCopy {
                HStack {
                    Spacer()
                    Button("Copy", action: onCopy)
                        .keyboardShortcut("c", modifiers: [.command])
                }
            }
        }
        .padding(16)
        .frame(width: 420)
    }

    private var headerTitle: String {
        switch content {
        case .translation:
            return "Translation"
        case .message(let title, _):
            return title
        }
    }

    @ViewBuilder
    private var panelBody: some View {
        switch content {
        case .translation(let result):
            VStack(alignment: .leading, spacing: 12) {
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
            }
        case .message(_, let body):
            Text(body)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
