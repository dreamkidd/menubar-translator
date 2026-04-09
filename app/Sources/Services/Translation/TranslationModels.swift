import Foundation

enum LanguageDirection: String, CaseIterable, Identifiable, Codable {
    case englishToChinese
    case chineseToEnglish

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .englishToChinese:
            return "English → Chinese"
        case .chineseToEnglish:
            return "Chinese → English"
        }
    }

    var sourceLanguageCode: String {
        switch self {
        case .englishToChinese:
            return "en"
        case .chineseToEnglish:
            return "zh"
        }
    }

    var targetLanguageCode: String {
        switch self {
        case .englishToChinese:
            return "zh"
        case .chineseToEnglish:
            return "en"
        }
    }
}

enum TranslationSourceType: String, Codable {
    case manualInput
    case clipboard
    case selectedText
}

struct TranslationRequest: Sendable {
    let text: String
    let direction: LanguageDirection
    let sourceType: TranslationSourceType
}

struct TranslationResult: Sendable {
    let sourceText: String
    let translatedText: String
    let detectedSourceLanguage: String
    let targetLanguage: String
    let sourceType: TranslationSourceType
}

enum TranslationError: LocalizedError {
    case emptyInput
    case unavailableTextSource
    case engineUnavailable
    case translationFailed(String)

    var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "No text was provided for translation."
        case .unavailableTextSource:
            return "No usable text was found from the current source."
        case .engineUnavailable:
            return "The translation engine is not ready yet."
        case .translationFailed(let message):
            return message
        }
    }
}
