import Foundation
import Alamofire
protocol ReachabilityProtocol {
    var isConnected: Bool { get }
}

final class ReachabilityManager: ReachabilityProtocol {
    static let shared = ReachabilityManager()
    private init() {}

    var mockIsConnected: Bool?
    var isConnected: Bool {
        if let mock = mockIsConnected { return mock }
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
