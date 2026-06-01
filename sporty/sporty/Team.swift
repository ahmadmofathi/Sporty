//
//  Team.swift
//  sporty
//
//  Created by Shady Ramadan on 01/06/2026.
//

import Foundation
struct TeamResponse: Codable {
    let success: Int?
    let result: [TeamData]?
}

struct TeamData: Codable {
    let teamKey: Int?
    let teamName: String?
    let players: [Player]?

    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case players
    }
}
