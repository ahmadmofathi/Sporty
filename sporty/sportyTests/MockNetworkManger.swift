import Foundation
@testable import sporty

class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var mockLeagues: [League] = []
    var mockTeams: [LeagueTeam] = []
    var mockFixtures: [Fixture] = []
    var mockTennisFixtures: [TennisFixture] = []
    var mockPlayers: [Player] = []
    var mockPlayerProfile: TennisPlayerProfile?
    
    func fetchLeagues(sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "NetworkError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Leagues fetch failed"])))
        } else {
            completion(.success(mockLeagues))
        }
    }
    
    func fetchTeams(leagueId: Int, sport: String, completion: @escaping (Result<[LeagueTeam], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "NetworkError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Teams fetch failed"])))
        } else {
            completion(.success(mockTeams))
        }
    }
    
    func fetchFixtures(leagueId: Int, sport: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "NetworkError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Fixtures fetch failed"])))
        } else {
            completion(.success(mockFixtures))
        }
    }
    
    func fetchPlayers(teamId: Int, sport: String, completion: @escaping (Result<[Player], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "NetworkError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Players fetch failed"])))
        } else {
            completion(.success(mockPlayers))
        }
    }
    
    func fetchTennisFixtures(leagueId: Int, completion: @escaping (Result<[TennisFixture], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "NetworkError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Tennis Fixtures fetch failed"])))
        } else {
            completion(.success(mockTennisFixtures))
        }
    }
    
    func fetchPlayerProfile(with playerKey: Int, completion: @escaping (Result<TennisPlayerProfile, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "NetworkError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Profile fetch failed"])))
        } else if let profile = mockPlayerProfile {
            completion(.success(profile))
        } else {
            completion(.failure(NSError(domain: "NetworkError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No player found"])))
        }
    }
    
    func fetchPlayerTournaments(playerKey: Int, completion: @escaping (Result<[TennisFixture], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "NetworkError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Tournaments fetch failed"])))
        } else {
            completion(.success(mockTennisFixtures))
        }
    }
}
