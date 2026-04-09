import Foundation

struct MockTranslationEngine: TranslationEngine {
    func translate(_ request: TranslationRequest) async throws -> TranslationResult {
        let sanitized = request.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sanitized.isEmpty else {
            throw TranslationError.emptyInput
        }

        try await Task.sleep(nanoseconds: 250_000_000)

        let translatedText: String
        switch request.direction {
        case .englishToChinese:
            translatedText = "[Mock 中文翻译] \(sanitized)"
        case .chineseToEnglish:
            translatedText = "[Mock English Translation] \(sanitized)"
        }

        return TranslationResult(
            sourceText: sanitized,
            translatedText: translatedText,
            detectedSourceLanguage: request.direction.sourceLanguageCode,
            targetLanguage: request.direction.targetLanguageCode,
            sourceType: request.sourceType
        )
    }
}
