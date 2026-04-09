import Foundation

enum FloatingPanelContent {
    case translation(TranslationResult)
    case message(title: String, body: String)
}
