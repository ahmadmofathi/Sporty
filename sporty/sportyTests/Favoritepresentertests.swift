import XCTest
import CoreData
@testable import sporty

class FavoritesPresenterTests: XCTestCase {

    var mockView: MockFavoritesView!
    var presenter: FavoritesPresenter!

    override func setUp() {
        super.setUp()
        CoreDataManager.shared.fetchAllFavorites().forEach {
            if let key = $0.leagueKey {
                CoreDataManager.shared.deleteLeague(byKey: key)
            }
        }
        mockView = MockFavoritesView()
        presenter = FavoritesPresenter(view: mockView)
    }

    override func tearDown() {
        mockView = nil
        presenter = nil
        super.tearDown()
    }

    func test_viewWillAppear_callsDisplayFavorites() {
        presenter.viewWillAppear()
        XCTAssertNotNil(mockView.displayedLeagues)
    }

    func test_fetchFavorites_empty_displaysEmpty() {
        presenter.fetchFavoritesFromCoreData()
        XCTAssertEqual(mockView.displayedLeagues.count, 0)
    }

    func test_fetchFavorites_withData_displaysLeagues() {
        let league = League(leagueKey: 111, leagueName: "Test League", countryKey: 1, countryName: "Egypt", leagueLogo: nil, countryLogo: nil)
        CoreDataManager.shared.saveLeague(league, sport: "football")

        presenter.fetchFavoritesFromCoreData()
        XCTAssertEqual(presenter.getFavoritesCount(), 1)

        CoreDataManager.shared.deleteLeague(byKey: 111)
    }

    func test_getFavoritesCount_returnsCorrectCount() {
        XCTAssertEqual(presenter.getFavoritesCount(), 0)
    }

    func test_getFavoriteLeague_validIndex_returnsLeague() {
        let league = League(leagueKey: 222, leagueName: "Serie A", countryKey: 2, countryName: "Italy", leagueLogo: nil, countryLogo: nil)
        CoreDataManager.shared.saveLeague(league, sport: "football")
        presenter.fetchFavoritesFromCoreData()

        let result = presenter.getFavoriteLeague(at: 0)
        XCTAssertNotNil(result)

        CoreDataManager.shared.deleteLeague(byKey: 222)
    }

    func test_getFavoriteLeague_outOfBounds_returnsNil() {
        let result = presenter.getFavoriteLeague(at: 99)
        XCTAssertNil(result)
    }

    func test_didSelectRow_validIndex_navigates() {
        let league = League(leagueKey: 333, leagueName: "Bundesliga", countryKey: 3, countryName: "Germany", leagueLogo: nil, countryLogo: nil)
        CoreDataManager.shared.saveLeague(league, sport: "football")
        presenter.fetchFavoritesFromCoreData()

        presenter.didSelectRow(at: 0)
        XCTAssertEqual(mockView.navigatedLeagueName, "Bundesliga")

        CoreDataManager.shared.deleteLeague(byKey: 333)
    }

    func test_didSelectRow_nilLeagueName_navigatesWithEmpty() {
        let league = League(leagueKey: 444, leagueName: nil, countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil)
        CoreDataManager.shared.saveLeague(league, sport: "football")
        presenter.fetchFavoritesFromCoreData()

        presenter.didSelectRow(at: 0)
        XCTAssertEqual(mockView.navigatedLeagueName, "")

        CoreDataManager.shared.deleteLeague(byKey: 444)
    }

    func test_didSelectRow_outOfBounds_doesNotNavigate() {
        presenter.didSelectRow(at: 99)
        XCTAssertNil(mockView.navigatedLeagueName)
    }

    func test_requestDeleteLeague_outOfBounds_doesNotShowAlert() {
        presenter.requestDeleteLeague(at: 99)
        XCTAssertNil(mockView.deleteAlertLeagueName)
    }

    func test_requestDeleteLeague_showsAlert() {
        let league = League(leagueKey: 555, leagueName: "Ligue 1", countryKey: 5, countryName: "France", leagueLogo: nil, countryLogo: nil)
        CoreDataManager.shared.saveLeague(league, sport: "football")
        presenter.fetchFavoritesFromCoreData()

        presenter.requestDeleteLeague(at: 0)
        XCTAssertEqual(mockView.deleteAlertLeagueName, "Ligue 1")

        CoreDataManager.shared.deleteLeague(byKey: 555)
    }

    func test_requestDeleteLeague_confirmHandler_deletesLeague() {
        let league = League(leagueKey: 666, leagueName: "MLS", countryKey: 6, countryName: "USA", leagueLogo: nil, countryLogo: nil)
        CoreDataManager.shared.saveLeague(league, sport: "football")
        presenter.fetchFavoritesFromCoreData()

        presenter.requestDeleteLeague(at: 0)
        mockView.deleteConfirmHandler?()

        XCTAssertFalse(CoreDataManager.shared.isLeagueFavorite(byKey: 666))
    }

    func test_requestDeleteLeague_nilLeagueName_usesUnknown() {
        let league = League(leagueKey: 777, leagueName: nil, countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil)
        CoreDataManager.shared.saveLeague(league, sport: "football")
        presenter.fetchFavoritesFromCoreData()

        presenter.requestDeleteLeague(at: 0)
        XCTAssertEqual(mockView.deleteAlertLeagueName, "Unknown League")

        CoreDataManager.shared.deleteLeague(byKey: 777)
    }

    func test_requestDeleteLeague_nilKey_confirmHandlerDoesNothing() {
        let league = League(leagueKey: nil, leagueName: "No Key League", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil)
        presenter.setLeaguesForTesting([league])

        presenter.requestDeleteLeague(at: 0)
        mockView.deleteConfirmHandler?()

        XCTAssertEqual(presenter.getFavoritesCount(), 1)
    }
}

extension FavoritesPresenter {
    func setLeaguesForTesting(_ leagues: [League]) {
        self.favoriteLeagues = leagues
    }
}
