import Foundation

struct LeaguesResponse: Codable {
    let success: Int?
    let result: [League]
}

struct League: Codable {
    let leagueKey: Int?
    let leagueName: String?
    let countryName: String?
    let leagueLogo: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
    }
}
