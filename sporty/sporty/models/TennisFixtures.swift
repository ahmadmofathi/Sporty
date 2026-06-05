import Foundation

struct TennisFixturesResponse: Codable {
    let success: Int?
    let result: [TennisFixture]?
}

struct TennisFixture: Codable, MatchProtocol {
    
    let eventDate: String?
    let eventTime: String?
    let eventFirstPlayer: String?
    let eventSecondPlayer: String?
    let eventFirstPlayerLogo: String?
    let eventSecondPlayerLogo: String?
    let eventFinalResult: String?
    
     var playerKey1: Int?
    var playerKey2: Int?

     var title1: String? { return eventFirstPlayer }
    var title2: String? { return eventSecondPlayer }
    var logo1: String? { return eventFirstPlayerLogo }
    var logo2: String? { return eventSecondPlayerLogo }
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
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventFirstPlayer = "event_first_player"
        case eventSecondPlayer = "event_second_player"
        case eventFirstPlayerLogo = "event_first_player_logo"
        case eventSecondPlayerLogo = "event_second_player_logo"
        case eventFinalResult = "event_final_result"
        case playerKey1 = "first_player_key"
        case playerKey2 = "second_player_key"
    }

     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.eventDate = try container.decodeIfPresent(String.self, forKey: .eventDate)
        self.eventTime = try container.decodeIfPresent(String.self, forKey: .eventTime)
        self.eventFirstPlayer = try container.decodeIfPresent(String.self, forKey: .eventFirstPlayer)
        self.eventSecondPlayer = try container.decodeIfPresent(String.self, forKey: .eventSecondPlayer)
        self.eventFirstPlayerLogo = try container.decodeIfPresent(String.self, forKey: .eventFirstPlayerLogo)
        self.eventSecondPlayerLogo = try container.decodeIfPresent(String.self, forKey: .eventSecondPlayerLogo)
        self.eventFinalResult = try container.decodeIfPresent(String.self, forKey: .eventFinalResult)
          if let intKey = try? container.decodeIfPresent(Int.self, forKey: .playerKey1) {
            self.playerKey1 = intKey
        } else if let stringKey = try? container.decodeIfPresent(String.self, forKey: .playerKey1), let intKey = Int(stringKey) {
            self.playerKey1 = intKey
        } else {
            self.playerKey1 = nil
        }
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .playerKey2) {
            self.playerKey2 = intKey
        } else if let stringKey = try? container.decodeIfPresent(String.self, forKey: .playerKey2), let intKey = Int(stringKey) {
            self.playerKey2 = intKey
        } else {
            self.playerKey2 = nil
        }
    }
}
