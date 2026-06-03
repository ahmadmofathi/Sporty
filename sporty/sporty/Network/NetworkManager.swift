import Foundation
import Alamofire

class NetworkManager {
    let apiKey = "53b3a058aedc852b1c141bc3c80078695068dc06342a6e408e3a390a7252cd27"

    static let shared = NetworkManager()

    private init() {}

    func fetchLeagues(sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        let safeSport = sport.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let url = "https://apiv2.allsportsapi.com/\(safeSport)/?met=Leagues&APIkey=\(apiKey)"

        AF.request(url)
            .validate()
            .responseDecodable(of: LeaguesResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data.result ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchPlayers(teamId: Int, completion: @escaping (Result<[Player], Error>) -> Void) {
        let url = "https://apiv2.allsportsapi.com/football/?met=Teams&teamId=\(teamId)&APIkey=\(apiKey)"

        AF.request(url)
            .validate()
            .responseDecodable(of: TeamResponse.self) { response in
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
    
    
    func fetchTeams(
        leagueId: Int,
        completion: @escaping (Result<[LeagueTeam], Error>) -> Void
    ) {

        let url =
        "https://apiv2.allsportsapi.com/football/?met=Teams&leagueId=\(leagueId)&APIkey=\(apiKey)"

        AF.request(url)
            .validate()
            .responseDecodable(of: LeagueTeamsResponse.self) { response in

                switch response.result {

                case .success(let data):
                    completion(.success(data.result ?? []))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    func fetchFixtures(
        leagueId: Int,
        completion: @escaping (Result<[Fixture], Error>) -> Void
    ) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let today = Date()

        let fromDate = formatter.string(
            from: Calendar.current.date(
                byAdding: .month,
                value: -1,
                to: today
            )!
        )

        let toDate = formatter.string(
            from: Calendar.current.date(
                byAdding: .month,
                value: 1,
                to: today
            )!
        )

        let url =
        "https://apiv2.allsportsapi.com/football/?" +
        "met=Fixtures" +
        "&leagueId=\(leagueId)" +
        "&from=\(fromDate)" +
        "&to=\(toDate)" +
        "&APIkey=\(apiKey)"

        print(url)

        AF.request(url)
            .validate()
            .responseDecodable(of: FixturesResponse.self) { response in

                switch response.result {

                case .success(let data):

                    print("Fixtures Count:",
                          data.result?.count ?? 0)

                    completion(
                        .success(data.result ?? [])
                    )

                case .failure(let error):

                    print("Fixtures Error:",
                          error.localizedDescription)

                    completion(
                        .failure(error)
                    )
                }
            }
    }
    
    
}
