import Foundation

protocol FavoritesViewProtocol: AnyObject {
    func displayFavorites(_ leagues: [League])
    func navigateToLeague(with leagueId: Int) // غيرنا النوع لـ Int
    func showDeleteConfirmationAlert(leagueName: String, confirmHandler: @escaping () -> Void)
}

class FavoritesPresenter {
    private weak var view: FavoritesViewProtocol?
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

    func didSelectRow(at index: Int) {
        guard index < favoriteLeagues.count else { return }
        // استخدام الـ leagueKey كـ id للذهاب للشاشة التالية
        let selectedLeagueId = Int(favoriteLeagues[index].leagueKey ?? 0) ?? 0
        view?.navigateToLeague(with: selectedLeagueId)
    }

    func requestDeleteLeague(at index: Int) {
        guard index < favoriteLeagues.count else { return }
        let league = favoriteLeagues[index]
        let name = league.leagueName ?? "Unknown League"

        view?.showDeleteConfirmationAlert(leagueName: name) { [weak self] in
            guard let self = self, let key = league.leagueKey else { return }
            CoreDataManager.shared.deleteLeague(byKey: key)
            self.fetchFavoritesFromCoreData()
        }
    }
}
