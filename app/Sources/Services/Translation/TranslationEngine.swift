import Foundation

protocol TranslationEngine {
    func translate(_ request: TranslationRequest) async throws -> TranslationResult
}
