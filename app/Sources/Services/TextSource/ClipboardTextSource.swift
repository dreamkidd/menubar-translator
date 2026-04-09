import AppKit
import Foundation

struct ClipboardTextSource {
    func readSanitizedText(maxLength: Int = 1_500) throws -> String {
        let pasteboard = NSPasteboard.general
        guard let rawText = pasteboard.string(forType: .string) else {
            throw TranslationError.unavailableTextSource
        }

        let cleaned = rawText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\r\n", with: "\n")

        guard !cleaned.isEmpty else {
            throw TranslationError.emptyInput
        }

        if cleaned.count <= maxLength {
            return cleaned
        }

        // The week-1 MVP intentionally prefers a deterministic hard limit over
        // trying to be smart about chunking or summarizing oversized clipboard input.
        // That keeps the first end-to-end flow stable while inference behavior is still fluid.
        return String(cleaned.prefix(maxLength))
    }
}
