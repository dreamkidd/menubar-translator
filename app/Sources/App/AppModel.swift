import Foundation
import SwiftUI

@MainActor
final class AppModel: ObservableObject {
    @Published var manualInput: String = ""
    @Published var currentDirection: LanguageDirection = .englishToChinese
    @Published var latestResult: TranslationResult?
    @Published var lastErrorMessage: String?
    @Published var isTranslating: Bool = false

    let translationEngine: TranslationEngine
    let clipboardTextSource: ClipboardTextSource
    let modelManager: ModelManager
    private let triggerCoordinator: TranslationTriggerCoordinator
    private let floatingPanelController = FloatingPanelController()

    init(
        translationEngine: TranslationEngine = MockTranslationEngine(),
        clipboardTextSource: ClipboardTextSource = ClipboardTextSource(),
        modelManager: ModelManager = ModelManager()
    ) {
        self.translationEngine = translationEngine
        self.clipboardTextSource = clipboardTextSource
        self.modelManager = modelManager
        self.triggerCoordinator = TranslationTriggerCoordinator(
            clipboardTextSource: clipboardTextSource,
            translationEngine: translationEngine
        )
    }

    func translateManualInput() {
        let text = manualInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            lastErrorMessage = TranslationError.emptyInput.localizedDescription
            return
        }

        let request = TranslationRequest(
            text: text,
            direction: currentDirection,
            sourceType: .manualInput
        )

        runTranslation(request: request, presentInFloatingPanel: false)
    }

    func translateClipboard() {
        isTranslating = true
        lastErrorMessage = nil

        Task {
            defer { isTranslating = false }

            do {
                let result = try await triggerCoordinator.translateFromClipboard(direction: currentDirection)
                latestResult = result
                floatingPanelController.show(result: result)
            } catch {
                lastErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        }
    }

    func copyLatestTranslation() {
        guard let translatedText = latestResult?.translatedText else { return }
        ClipboardWriter.write(text: translatedText)
    }

    private func runTranslation(request: TranslationRequest, presentInFloatingPanel: Bool) {
        isTranslating = true
        lastErrorMessage = nil

        Task {
            defer { isTranslating = false }

            do {
                let result = try await translationEngine.translate(request)
                latestResult = result

                // The floating panel is intentionally optional here:
                // menu bar input should stay lightweight, while shortcut-triggered
                // translation can feel more system-level and ambient.
                if presentInFloatingPanel {
                    floatingPanelController.show(result: result)
                }
            } catch {
                lastErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        }
    }
}
