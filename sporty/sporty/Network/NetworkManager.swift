import Foundation
import Alamofire
protocol NetworkManagerProtocol {
    func fetchLeagues(sport: String, completion: @escaping (Result<[League], Error>) -> Void)
    func fetchTeams(leagueId: Int, sport: String, completion: @escaping (Result<[LeagueTeam], Error>) -> Void)
    func fetchFixtures(leagueId: Int, sport: String, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func fetchPlayers(teamId: Int, sport: String, completion: @escaping (Result<[Player], Error>) -> Void)
    func fetchTennisFixtures(leagueId: Int, completion: @escaping (Result<[TennisFixture], Error>) -> Void)
    func fetchPlayerProfile(with playerKey: Int, completion: @escaping (Result<TennisPlayerProfile, Error>) -> Void)
    func fetchPlayerTournaments(playerKey: Int, completion: @escaping (Result<[TennisFixture], Error>) -> Void)
}
class NetworkManager : NetworkManagerProtocol{
    let apiKey = "53b3a058aedc852b1c141bc3c80078695068dc06342a6e408e3a390a7252cd27"
    static let shared = NetworkManager()
    private init() {}
    
    func fetchLeagues(sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        let url = "https://apiv2.allsportsapi.com/\(sport.lowercased())/?met=Leagues&APIkey=\(apiKey)"
        AF.request(url).validate().responseDecodable(of: LeaguesResponse.self) { response in
            completion(response.result.map { $0.result ?? [] }.mapError { $0 as Error })
        }
    }
    
    func fetchTeams(leagueId: Int, sport: String, completion: @escaping (Result<[LeagueTeam], Error>) -> Void) {
        let url = "https://apiv2.allsportsapi.com/\(sport.lowercased())/?met=Teams&leagueId=\(leagueId)&APIkey=\(apiKey)"
        AF.request(url).validate().responseDecodable(of: LeagueTeamsResponse.self) { response in
            completion(response.result.map { $0.result ?? [] }.mapError { $0 as Error })
        }
    }
    
    func fetchFixtures(leagueId: Int, sport: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let fromDate = formatter.string(from: Calendar.current.date(byAdding: .year, value: -1, to: today)!)
        let toDate = formatter.string(from: Calendar.current.date(byAdding: .year, value: 1, to: today)!)
        let url = "https://apiv2.allsportsapi.com/\(sport.lowercased())/?met=Fixtures&leagueId=\(leagueId)&from=\(fromDate)&to=\(toDate)&APIkey=\(apiKey)"
        AF.request(url).validate().responseDecodable(of: FixturesResponse.self) { response in
            completion(response.result.map { $0.result ?? [] }.mapError { $0 as Error })
        }
    }
    
    func fetchPlayers(teamId: Int, sport: String, completion: @escaping (Result<[Player], Error>) -> Void) {
        let url = "https://apiv2.allsportsapi.com/\(sport.lowercased())/?met=Teams&teamId=\(teamId)&APIkey=\(apiKey)"
        AF.request(url).validate().responseDecodable(of: TeamResponse.self) { response in
            switch response.result {
            case .success(let data):
                if let firstTeam = data.result?.first {
                    completion(.success(firstTeam.players ?? []))
                } else {
                    completion(.success([]))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTennisFixtures(leagueId: Int, completion: @escaping (Result<[TennisFixture], Error>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: -6, to: today) ?? today
        let endDate = calendar.date(byAdding: .month, value: 6, to: today) ?? today
        let fromDateString = formatter.string(from: startDate)
        let toDateString = formatter.string(from: endDate)
        let url = "https://apiv2.allsportsapi.com/tennis/?met=Fixtures&leagueId=\(leagueId)&from=\(fromDateString)&to=\(toDateString)&APIkey=\(apiKey)"
        AF.request(url).validate().responseDecodable(of: TennisFixturesResponse.self) { response in
            switch response.result {
            case .success(let data):
                if response.response?.statusCode == 200 && data.success == 1 {
                    completion(.success(data.result ?? []))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlayerProfile(with playerKey: Int, completion: @escaping (Result<TennisPlayerProfile, Error>) -> Void) {
        let url = "https://apiv2.allsportsapi.com/tennis/"
        let parameters: [String: Any] = [
            "met": "Players",
            "playerId": "\(playerKey)",
            "APIkey": apiKey
        ]
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: TennisResponse.self) { response in
            if let data = response.data, let json = String(data: data, encoding: .utf8) {
                print("🎾 Player Response: \(json)")
            }
            switch response.result {
            case .success(let data):
                if let profile = data.result?.first {
                    completion(.success(profile))
                } else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No data for this player"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlayerTournaments(playerKey: Int, completion: @escaping (Result<[TennisFixture], Error>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let from = formatter.string(from: Calendar.current.date(byAdding: .year, value: -2, to: today)!)
        let to = formatter.string(from: today)
        let url = "https://apiv2.allsportsapi.com/tennis/?met=Fixtures&playerId=\(playerKey)&from=\(from)&to=\(to)&APIkey=\(apiKey)"
        AF.request(url).validate().responseDecodable(of: TennisFixturesResponse.self) { response in
            if let data = response.data, let json = String(data: data, encoding: .utf8) {
                print("🎾 Tournaments Response: \(json)")
            }
            switch response.result {
            case .success(let data):
                completion(.success(data.result ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

