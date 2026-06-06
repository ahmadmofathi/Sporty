import Foundation
@testable import sporty

class MockReachabilityManager: ReachabilityProtocol {
    var isConnected: Bool = true
}
