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
    
       init(teamKey: Int?, teamName: String?, teamLogo: String?) {
            self.teamKey = teamKey
            self.teamName = teamName
            self.teamLogo = teamLogo
        }
       init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.teamName = try container.decodeIfPresent(String.self, forKey: .teamName)
        self.teamLogo = try container.decodeIfPresent(String.self, forKey: .teamLogo)
        
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .teamKey) {
            self.teamKey = intKey
        } else if let stringKey = try? container.decodeIfPresent(String.self, forKey: .teamKey), let intKey = Int(stringKey) {
            self.teamKey = intKey
        } else {
            self.teamKey = nil
        }
    }
}
