//
//  Fixtures.swift
//  sporty
//
//  Created by Shady Ramadan on 03/06/2026.
//

import Foundation
struct FixturesResponse: Codable {
    let success: Int?
    let result: [Fixture]?
}
struct Fixture: Codable {

    let eventDate: String?
    let eventHomeTeam: String?
    let eventAwayTeam: String?
    let eventFinalResult: String?
    let leagueRound: String?

    let homeTeamLogo: String?
    let awayTeamLogo: String?

    enum CodingKeys: String, CodingKey {

        case eventDate = "event_date"
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case eventFinalResult = "event_final_result"
        case leagueRound = "league_round"

        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
    }
}

