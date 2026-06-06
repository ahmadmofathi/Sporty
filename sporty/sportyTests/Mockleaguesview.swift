import XCTest
@testable import sporty

class MockLeaguesView: LeaguesViewProtocol {
    var displayedNames: [String] = []
    var displayedCountries: [String] = []
    var displayedLogos: [String] = []
    var displayedFavorites: [Bool] = []
    var navigatedLeagueId: Int?
    var noInternetCalled = false
    var emptyStateMessage: String?
    var hideEmptyStateCalled = false

    func displayLeagues(_ names: [String], countries: [String], logos: [String], favorites: [Bool]) {
        displayedNames = names
        displayedCountries = countries
        displayedLogos = logos
        displayedFavorites = favorites
    }

    func navigateToLeague(with leagueId: Int) {
        navigatedLeagueId = leagueId
    }

    func showNoInternet() {
        noInternetCalled = true
    }

    func showEmptyState(message: String) {
        emptyStateMessage = message
    }

    func hideEmptyState() {
        hideEmptyStateCalled = true
    }
}
