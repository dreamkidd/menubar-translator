import Foundation

@MainActor
final class ModelManager: ObservableObject {
    enum Status {
        case notConfigured
        case ready
        case unavailable(reason: String)

        var description: String {
            switch self {
            case .notConfigured:
                return "Not configured"
            case .ready:
                return "Ready"
            case .unavailable(let reason):
                return "Unavailable: \(reason)"
            }
        }
    }

    @Published private(set) var status: Status = .notConfigured

    func markReady() {
        status = .ready
    }

    func markUnavailable(reason: String) {
        status = .unavailable(reason: reason)
    }
}
