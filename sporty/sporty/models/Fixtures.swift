import Foundation

protocol MatchProtocol {
    var title1: String? { get }
    var title2: String? { get }
    var logo1: String? { get }
    var logo2: String? { get }
    var result: String? { get }
    var isUpcoming: Bool { get }
    var date: String? { get }
    var time: String? { get }
    var playerKey1: Int? { get }
    var playerKey2: Int? { get }
}

struct FixturesResponse: Codable {
    let success: Int?
    let result: [Fixture]?
}

struct Fixture: Codable, MatchProtocol {
    var playerKey1: Int?
    
    var playerKey2: Int?
    
    let eventKey: Int?
    let eventDate: String?
    let eventTime: String?
    let eventHomeTeam: String?
    let eventAwayTeam: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let eventFinalResult : String?

    var title1: String? { return eventHomeTeam }
    var title2: String? { return eventAwayTeam }
    var logo1: String? { return homeTeamLogo }
    var logo2: String? { return awayTeamLogo }
    var result: String? { return eventFinalResult }
    var date: String? { return eventDate }
    var time: String? { return eventTime }

    var isUpcoming: Bool {
        guard let dateString = eventDate else { return false }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dateObj = formatter.date(from: dateString) {
            return dateObj > Date()
        }
        return false
    }

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventFinalResult = "event_final_result"
    }
}
