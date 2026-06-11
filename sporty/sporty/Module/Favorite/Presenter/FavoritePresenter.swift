import Foundation

protocol FavoritesViewProtocol: AnyObject {
    func displayFavorites(_ leagues: [League])
    func navigateToLeague(with leagueId: Int) // غيرنا النوع لـ Int
    func showDeleteConfirmationAlert(leagueName: String, confirmHandler: @escaping () -> Void)
}

class FavoritesPresenter {

    private weak var view: FavoritesViewProtocol?
    // internal (مش private) عشان extension في الـ tests يقدر يكتب عليها
    var favoriteLeagues: [League] = []

    init(view: FavoritesViewProtocol) {
        self.view = view
    }

    func viewWillAppear() {
        fetchFavoritesFromCoreData()
    }

    func fetchFavoritesFromCoreData() {
        self.favoriteLeagues = CoreDataManager.shared.fetchAllFavorites()
        self.view?.displayFavorites(favoriteLeagues)
    }

    func getFavoritesCount() -> Int {
        return favoriteLeagues.count
    }

    func getFavoriteLeague(at index: Int) -> League? {
        guard index < favoriteLeagues.count else { return nil }
        return favoriteLeagues[index]
    }

    func didSelectRow(at index: Int) {
        guard index < favoriteLeagues.count else { return }
        let selectedLeagueId = Int(String(describing: favoriteLeagues[index].leagueKey ?? 0)) ?? 0
        view?.navigateToLeague(with: selectedLeagueId)
    }

    func requestDeleteLeague(at index: Int) {
        guard index < favoriteLeagues.count else { return }
        let league = favoriteLeagues[index]
        let name = league.leagueName ?? L10n.General.unknownLeague

        view?.showDeleteConfirmationAlert(leagueName: name) { [weak self] in
            guard let self = self, let key = league.leagueKey else { return }
            CoreDataManager.shared.deleteLeague(byKey: key)
            self.fetchFavoritesFromCoreData()
        }
    }
}
