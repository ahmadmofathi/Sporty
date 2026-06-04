import Foundation

struct TennisFixturesResponse: Codable {
    let success: Int?
    let result: [TennisFixture]?
}

struct TennisFixture: Codable, MatchProtocol {
    let eventKey: Int?
    let eventDate: String?
    let eventTime: String?
    let eventFinalResult: String?
    let eventStatus: String?
    let eventFirstPlayer: String?
    let eventSecondPlayer: String?
    let eventFirstPlayerLogo: String?
    let eventSecondPlayerLogo: String?
    let eventHomeTeam: String?
    let eventAwayTeam: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?

    var title1: String? { return (eventFirstPlayer?.isEmpty == false) ? eventFirstPlayer : eventHomeTeam }
    var title2: String? { return (eventSecondPlayer?.isEmpty == false) ? eventSecondPlayer : eventAwayTeam }
    
    var date: String? { return eventDate }
    var time: String? { return eventTime }
    var result: String? { return eventFinalResult }

       var logo1: String? {
        let logo = (eventFirstPlayerLogo?.isEmpty == false) ? eventFirstPlayerLogo : homeTeamLogo
        return logo?.isEmpty == false ? logo : nil
    }

    var logo2: String? {
        let logo = (eventSecondPlayerLogo?.isEmpty == false) ? eventSecondPlayerLogo : awayTeamLogo
        return logo?.isEmpty == false ? logo : nil
    }

    var isUpcoming: Bool {
        if let res = eventFinalResult, res != "-", !res.isEmpty { return false }
        if let status = eventStatus?.lowercased(), status == "finished" { return false }
        return true
    }

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventFinalResult = "event_final_result"
        case eventStatus = "event_status"
        
        case eventFirstPlayer = "event_first_player"
        case eventSecondPlayer = "event_second_player"
        case eventFirstPlayerLogo = "event_first_player_logo"
        case eventSecondPlayerLogo = "event_second_player_logo"
        
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
    }
}
