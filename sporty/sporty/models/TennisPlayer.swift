import Foundation

struct TennisResponse: Codable {
    let success: Int?
    let result: [TennisPlayerProfile]?
}

struct TennisPlayerProfile: Codable {
    let playerKey: Int?
    let name: String?
    let nation: String?
    let imageURL: String?
    let birthDate: String?
    let stats: [YearlyStat]?
    let tournaments: [TournamentStat]?

    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case name = "player_name"
        case nation = "player_country"
        case imageURL = "player_logo"
        case birthDate = "player_bday"
        case stats = "stats"
        case tournaments = "tournaments"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.nation = try container.decodeIfPresent(String.self, forKey: .nation)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate)
        self.stats = try container.decodeIfPresent([YearlyStat].self, forKey: .stats)
        self.tournaments = try container.decodeIfPresent([TournamentStat].self, forKey: .tournaments)

        if let i = try? container.decodeIfPresent(Int.self, forKey: .playerKey) {
            self.playerKey = i
        } else if let s = try? container.decodeIfPresent(String.self, forKey: .playerKey), let i = Int(s) {
            self.playerKey = i
        } else {
            self.playerKey = nil
        }
    }
}

struct YearlyStat: Codable {
    let year: String?
    let type: String?
    let rank: String?
    let titles: String?
    let matchesWon: String?
    let matchesLost: String?

    enum CodingKeys: String, CodingKey {
        case year = "season"
        case type = "type"
        case rank = "rank"
        case titles = "titles"
        case matchesWon = "matches_won"
        case matchesLost = "matches_lost"
    }
}

struct TournamentStat: Codable {
    let name: String?
    let season: String?
    let type: String?
    let surface: String?
    let prize: String?

    enum CodingKeys: String, CodingKey {
        case name, season, type, surface, prize
    }
}
