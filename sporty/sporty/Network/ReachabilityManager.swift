//
//  ReachabilityManager.swift
//  sporty
//
//  Created by Ahmad on 04/06/2026.
//

import Foundation
import Alamofire

final class ReachabilityManager {

    static let shared = ReachabilityManager()

    private init() {}

    var isConnected: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
