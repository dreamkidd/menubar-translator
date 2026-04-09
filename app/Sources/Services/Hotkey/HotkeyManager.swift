import Foundation

final class HotkeyManager {
    var onTrigger: (() -> Void)?

    func registerDefaultHotkey() {
        // Placeholder for week-1 skeleton.
        // The actual implementation can use Carbon, AppKit, or a small dedicated
        // hotkey wrapper once we finalize the preferred native approach.
    }

    func simulateTrigger() {
        onTrigger?()
    }
}
