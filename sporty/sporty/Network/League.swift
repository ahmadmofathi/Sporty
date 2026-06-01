//
//  League.swift
//  sporty
//
//  Created by Ahmad on 01/06/2026.
//

import Foundation

struct LeaguesResponse: Codable {
    let success: Int?
    let result: [League]
}

struct League: Codable {
    let leagueKey: Int?
    let leagueName: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
    }
}
