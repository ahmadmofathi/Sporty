import XCTest
@testable import sporty

class MockCoreDataManager {
    var savedLeagues: [Int: (League, String)] = [:]

    func saveLeague(_ league: League, sport: String) {
        guard let key = league.leagueKey else { return }
        if isLeagueFavorite(byKey: key) { return }
        savedLeagues[key] = (league, sport)
    }

    func deleteLeague(byKey key: Int) {
        savedLeagues.removeValue(forKey: key)
    }

    func isLeagueFavorite(byKey key: Int) -> Bool {
        return savedLeagues[key] != nil
    }

    func fetchAllFavorites() -> [League] {
        return savedLeagues.values.map { $0.0 }
    }
}
