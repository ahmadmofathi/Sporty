import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func displayLeagues(_ names: [String], countries: [String], logos: [String], favorites: [Bool])
    func navigateToLeague(with leagueId: Int)
    func showNoInternet()
    func showEmptyState(message: String)
    func hideEmptyState()
}

class LeaguePresenter {

    private weak var view: LeaguesViewProtocol?

    var leagues: [League] = []
    var filteredLeagues: [League] = []

    var Sport: String?

    private var networkManager: NetworkManagerProtocol
    private var reachability: ReachabilityProtocol

    init(view: LeaguesViewProtocol,
         sport: String,
         networkManager: NetworkManagerProtocol = NetworkManager.shared,
         reachability: ReachabilityProtocol = ReachabilityManager.shared) {
        self.view = view
        self.Sport = sport
        self.networkManager = networkManager
        self.reachability = reachability
    }

    func viewDidLoad() {

        guard reachability.isConnected else {
            view?.showNoInternet()
            return
        }

        networkManager.fetchLeagues(sport: self.Sport ?? "football") { [weak self] result in

            guard let self = self else { return }

            switch result {

            case .success(let fetchedLeagues):
                self.leagues = fetchedLeagues
                self.filteredLeagues = fetchedLeagues

                if fetchedLeagues.isEmpty {
                    DispatchQueue.main.async {
                        self.view?.showEmptyState(message: L10n.Empty.noLeagues)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.hideEmptyState()
                        self.updateView()
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showEmptyState(message: L10n.Empty.failedLeagues)
                }
            }
        }
    }

    func filterLeagues(with text: String) {

        if text.isEmpty {
            filteredLeagues = leagues
        } else {
            filteredLeagues = leagues.filter { league in
                let name = league.leagueName?.lowercased() ?? ""
                let country = league.countryName?.lowercased() ?? ""
                return name.contains(text.lowercased()) || country.contains(text.lowercased())
            }
        }

        updateView()
    }

    func toggleFavorite(at index: Int) {

        guard index < filteredLeagues.count else { return }

        let league = filteredLeagues[index]
        guard let key = league.leagueKey else { return }

        if CoreDataManager.shared.isLeagueFavorite(byKey: key) {
            CoreDataManager.shared.deleteLeague(byKey: key)
        } else {
            CoreDataManager.shared.saveLeague(league, sport: self.Sport ?? "football")
        }

        updateView()
    }

    private func updateView() {

        let names     = filteredLeagues.map { $0.leagueName  ?? L10n.General.unknownLeague }
        let countries = filteredLeagues.map { $0.countryName ?? L10n.General.unknownCountry }
        let logos     = filteredLeagues.map { $0.leagueLogo  ?? "" }
        let favorites = filteredLeagues.map {
            CoreDataManager.shared.isLeagueFavorite(byKey: $0.leagueKey ?? 0)
        }

        view?.displayLeagues(names, countries: countries, logos: logos, favorites: favorites)
    }

    func didSelectLeague(at index: Int) {

        guard index < filteredLeagues.count else { return }

        let leagueId = filteredLeagues[index].leagueKey ?? 0
        view?.navigateToLeague(with: leagueId)
    }
}
