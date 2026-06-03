import Foundation

struct FixturesResponse: Codable {
    let success: Int?
    let result: [Fixture]?
}

struct Fixture: Codable {
    let eventKey: Int?
    let eventDate: String?
    let eventTime: String?
    let eventHomeTeam: String?
    let eventAwayTeam: String?
    let eventFinalResult: String?
    let leagueRound: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?

      var isUpcoming: Bool {
        guard let dateString = eventDate else { return false }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" 
        if let date = formatter.date(from: dateString) {
            return date > Date()
        }
        return false
    }
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case eventFinalResult = "event_final_result"
        case leagueRound = "league_round"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
    }
}
