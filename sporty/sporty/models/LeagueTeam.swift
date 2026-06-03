//
//  LeagueTeam.swift
//  sporty
//
//  Created by Shady Ramadan on 03/06/2026.
//

import Foundation
struct LeagueTeamsResponse: Codable {
    let success: Int?
    let result: [LeagueTeam]?
}
struct LeagueTeam: Codable {

    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?

    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    }
}
