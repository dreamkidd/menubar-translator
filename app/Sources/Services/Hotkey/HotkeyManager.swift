import Carbon
import Foundation

struct HotkeyDescriptor {
    let keyCode: UInt32
    let carbonModifiers: UInt32

    static let weekOneDefault = HotkeyDescriptor(
        keyCode: UInt32(kVK_ANSI_T),
        carbonModifiers: UInt32(cmdKey | shiftKey)
    )
}

final class HotkeyManager {
    var onTrigger: (() -> Void)?

    private var hotKeyRef: EventHotKeyRef?
    private var eventHandlerRef: EventHandlerRef?
    private let hotKeyID = EventHotKeyID(signature: HotkeyManager.signature, id: 1)

    func registerDefaultHotkey() {
        register(hotkey: .weekOneDefault)
    }

    func register(hotkey: HotkeyDescriptor) {
        unregister()
        installHandlerIfNeeded()

        RegisterEventHotKey(
            hotkey.keyCode,
            hotkey.carbonModifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
    }

    func unregister() {
        if let hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }
    }

    func simulateTrigger() {
        onTrigger?()
    }

    deinit {
        unregister()

        if let eventHandlerRef {
            RemoveEventHandler(eventHandlerRef)
        }
    }

    private func installHandlerIfNeeded() {
        guard eventHandlerRef == nil else { return }

        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )

        let userData = Unmanaged.passUnretained(self).toOpaque()

        InstallEventHandler(
            GetApplicationEventTarget(),
            { _, event, userData in
                guard let userData else { return noErr }
                let manager = Unmanaged<HotkeyManager>.fromOpaque(userData).takeUnretainedValue()
                return manager.handleHotkeyEvent(event)
            },
            1,
            &eventType,
            userData,
            &eventHandlerRef
        )
    }

    private func handleHotkeyEvent(_ event: EventRef?) -> OSStatus {
        guard let event else { return noErr }

        var hotKeyID = EventHotKeyID()
        let status = GetEventParameter(
            event,
            EventParamName(kEventParamDirectObject),
            EventParamType(typeEventHotKeyID),
            nil,
            MemoryLayout<EventHotKeyID>.size,
            nil,
            &hotKeyID
        )

        guard status == noErr else { return status }
        guard hotKeyID.signature == hotKeyIDExpected.signature, hotKeyID.id == hotKeyIDExpected.id else {
            return noErr
        }

        DispatchQueue.main.async { [onTrigger] in
            onTrigger?()
        }

        return noErr
    }

    private var hotKeyIDExpected: EventHotKeyID {
        hotKeyID
    }

    private static let signature: OSType = fourCharCode(from: "MBTR")
}

private func fourCharCode(from string: String) -> OSType {
    string.utf8.reduce(0) { partialResult, character in
        (partialResult << 8) + OSType(character)
    }
}
