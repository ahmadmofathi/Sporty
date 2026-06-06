import XCTest
@testable import sporty

class MockFavoritesView: FavoritesViewProtocol {
    
    var displayedLeagues: [League] = []
    var navigatedLeagueId: Int? // تم التعديل لتخزين الـ ID كرقم
    var deleteAlertLeagueName: String?
    var deleteConfirmHandler: (() -> Void)?

    func displayFavorites(_ leagues: [League]) {
        displayedLeagues = leagues
    }

    func navigateToLeague(with leagueId: Int) {
        navigatedLeagueId = leagueId // تم إزالة <#code#> وحفظ الـ ID
    }

    func showDeleteConfirmationAlert(leagueName: String, confirmHandler: @escaping () -> Void) {
        deleteAlertLeagueName = leagueName
        deleteConfirmHandler = confirmHandler
    }
}
