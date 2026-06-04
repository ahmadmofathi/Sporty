import Foundation
import Alamofire

class NetworkManager {
    let apiKey = "53b3a058aedc852b1c141bc3c80078695068dc06342a6e408e3a390a7252cd27"
    static let shared = NetworkManager()
    private init() {}

    // جلب الدوريات
    func fetchLeagues(sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        let url = "https://apiv2.allsportsapi.com/\(sport.lowercased())/?met=Leagues&APIkey=\(apiKey)"
        AF.request(url).validate().responseDecodable(of: LeaguesResponse.self) { response in
            completion(response.result.map { $0.result ?? [] }.mapError { $0 as Error })
        }
    }
    
    // جلب الفرق
    func fetchTeams(leagueId: Int, sport: String, completion: @escaping (Result<[LeagueTeam], Error>) -> Void) {
        let url = "https://apiv2.allsportsapi.com/\(sport.lowercased())/?met=Teams&leagueId=\(leagueId)&APIkey=\(apiKey)"
        AF.request(url).validate().responseDecodable(of: LeagueTeamsResponse.self) { response in
            completion(response.result.map { $0.result ?? [] }.mapError { $0 as Error })
        }
    }
    
    // جلب المباريات
    func fetchFixtures(leagueId: Int, sport: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let fromDate = formatter.string(from: Calendar.current.date(byAdding: .month, value: -1, to: today)!)
        let toDate = formatter.string(from: Calendar.current.date(byAdding: .month, value: 1, to: today)!)
        
        let url = "https://apiv2.allsportsapi.com/\(sport.lowercased())/?met=Fixtures&leagueId=\(leagueId)&from=\(fromDate)&to=\(toDate)&APIkey=\(apiKey)"
        
        AF.request(url).validate().responseDecodable(of: FixturesResponse.self) { response in
            completion(response.result.map { $0.result ?? [] }.mapError { $0 as Error })
        }
    }

    // جلب اللاعبين (مهمة جداً لشاشة Squad)
    func fetchPlayers(teamId: Int, sport: String, completion: @escaping (Result<[Player], Error>) -> Void) {
        // غالباً الـ Players بتيجي من الـ Teams endpoint
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
}
