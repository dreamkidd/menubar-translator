import AppKit
import SwiftUI

@MainActor
final class FloatingPanelController {
    private var panel: NSPanel?

    func show(result: TranslationResult) {
        let content = FloatingPanelContent.translation(result)
        showPanel(content: content, copyText: result.translatedText)
    }

    func showMessage(title: String, body: String) {
        let content = FloatingPanelContent.message(title: title, body: body)
        showPanel(content: content, copyText: nil)
    }

    private func showPanel(content: FloatingPanelContent, copyText: String?) {
        if panel == nil {
            panel = makePanel()
        }

        guard let panel else { return }

        let rootView = FloatingResultPanelView(
            content: content,
            onCopy: copyText.map { text in { ClipboardWriter.write(text: text) } },
            onClose: { [weak panel] in panel?.orderOut(nil) }
        )

        panel.contentView = NSHostingView(rootView: rootView)
        position(panel: panel)
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func makePanel() -> NSPanel {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 420, height: 260),
            styleMask: [.titled, .nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.hidesOnDeactivate = false
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true
        return panel
    }

    private func position(panel: NSPanel) {
        guard let screenFrame = NSScreen.main?.visibleFrame else { return }
        let size = panel.frame.size
        let origin = CGPoint(
            x: screenFrame.midX - size.width / 2,
            y: screenFrame.midY - size.height / 2
        )
        panel.setFrameOrigin(origin)
    }
}
