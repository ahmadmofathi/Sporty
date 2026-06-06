import XCTest
@testable import sporty

class MockFavoritesView: FavoritesViewProtocol {
    var displayedLeagues: [League] = []
    var navigatedLeagueName: String?
    var deleteAlertLeagueName: String?
    var deleteConfirmHandler: (() -> Void)?

    func displayFavorites(_ leagues: [League]) {
        displayedLeagues = leagues
    }

    func navigateToLeague(with leagueName: String) {
        navigatedLeagueName = leagueName
    }

    func showDeleteConfirmationAlert(leagueName: String, confirmHandler: @escaping () -> Void) {
        deleteAlertLeagueName = leagueName
        deleteConfirmHandler = confirmHandler
    }
}
