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
    private let hotkeyManager: HotkeyManager
    private let floatingPanelController = FloatingPanelController()

    init(
        translationEngine: TranslationEngine = MockTranslationEngine(),
        clipboardTextSource: ClipboardTextSource = ClipboardTextSource(),
        modelManager: ModelManager = ModelManager()
    ) {
        let hotkeyManager = HotkeyManager()

        self.translationEngine = translationEngine
        self.clipboardTextSource = clipboardTextSource
        self.modelManager = modelManager
        self.triggerCoordinator = TranslationTriggerCoordinator(
            clipboardTextSource: clipboardTextSource,
            translationEngine: translationEngine
        )
        self.hotkeyManager = hotkeyManager

        hotkeyManager.onTrigger = { [weak self] in
            Task { @MainActor in
                self?.handleGlobalShortcutTrigger()
            }
        }
        hotkeyManager.registerDefaultHotkey()
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
        handleClipboardTranslation(showFloatingPanelOnSuccess: true, showFloatingPanelOnFailure: false)
    }

    func copyLatestTranslation() {
        guard let translatedText = latestResult?.translatedText else { return }
        ClipboardWriter.write(text: translatedText)
    }

    private func handleGlobalShortcutTrigger() {
        handleClipboardTranslation(showFloatingPanelOnSuccess: true, showFloatingPanelOnFailure: true)
    }

    private func handleClipboardTranslation(showFloatingPanelOnSuccess: Bool, showFloatingPanelOnFailure: Bool) {
        isTranslating = true
        lastErrorMessage = nil

        Task {
            defer { isTranslating = false }

            do {
                let result = try await triggerCoordinator.translateFromClipboard(direction: currentDirection)
                latestResult = result

                if showFloatingPanelOnSuccess {
                    floatingPanelController.show(result: result)
                }
            } catch {
                let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                lastErrorMessage = message

                if showFloatingPanelOnFailure {
                    floatingPanelController.showMessage(
                        title: "Translation Unavailable",
                        body: "No usable text was found. Copy some text first or use the menu bar input.\n\nDetails: \(message)"
                    )
                }
            }
        }
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
