import Foundation

class TennisPlayerPresenter {

    private weak var view: TennisPlayerViewProtocol?
    private let networkManager: NetworkManagerProtocol
    private var playerProfile: TennisPlayerProfile?
    private var tournaments: [TennisFixture] = []
    var leagueId: Int = 0

    init(view: TennisPlayerViewProtocol,networkManger: NetworkManagerProtocol = NetworkManager.shared) {
        self.view = view
        self.networkManager = networkManger
    }

    func fetchPlayerDetails(playerKey: Int) {
        view?.showLoading()
        networkManager.fetchPlayerProfile(with: playerKey) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.playerProfile = profile
                self.view?.displayPlayerProfile(profile)
                self.fetchTournaments(playerKey: playerKey)
            case .failure(let error):
                self.view?.hideLoading()
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }

    private func fetchTournaments(playerKey: Int) {
        NetworkManager.shared.fetchTennisFixtures(leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoading()
            if case .success(let data) = result {
                self.tournaments = data.filter {
                    $0.playerKey1 == playerKey || $0.playerKey2 == playerKey
                }
                self.view?.reloadStatsTable()
            }
        }
    }

    func getNumberOfRows(for segment: Int) -> Int {
        if segment == 0 {
            return playerProfile?.stats?.count ?? 0
        } else {
            let apiTournaments = playerProfile?.tournaments?.count ?? 0
            return apiTournaments > 0 ? apiTournaments : tournaments.count
        }
    }

    func getStat(at index: Int) -> YearlyStat? {
        return playerProfile?.stats?[index]
    }

    func getTournament(at index: Int) -> TennisFixture? {
        guard index < tournaments.count else { return nil }
        return tournaments[index]
    }

    func getApiTournament(at index: Int) -> TournamentStat? {
        return playerProfile?.tournaments?[index]
    }

    func getBestRank() -> String {
        let ranks = playerProfile?.stats?
            .compactMap { $0.rank }
            .filter { !$0.isEmpty }
            .compactMap { Int($0) } ?? []
        if let best = ranks.min() {
            return "#\(best)"
        }
        return "-"
    }

    func getProSince() -> String {
        let years = playerProfile?.stats?
            .compactMap { $0.year }
            .filter { !$0.isEmpty }
            .compactMap { Int($0) } ?? []
        if let earliest = years.min() {
            return "\(earliest)"
        }
        return "-"
    }

    func getTotalTitles() -> String {
        let total = playerProfile?.stats?
            .compactMap { $0.titles }
            .compactMap { Int($0) }
            .reduce(0, +) ?? 0
        return "\(total)"
    }
}
