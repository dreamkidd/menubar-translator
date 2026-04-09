import Foundation

struct TranslationTriggerCoordinator {
    let clipboardTextSource: ClipboardTextSource
    let translationEngine: TranslationEngine

    func translateFromClipboard(direction: LanguageDirection) async throws -> TranslationResult {
        let text = try clipboardTextSource.readSanitizedText()
        let request = TranslationRequest(
            text: text,
            direction: direction,
            sourceType: .clipboard
        )
        return try await translationEngine.translate(request)
    }
}
