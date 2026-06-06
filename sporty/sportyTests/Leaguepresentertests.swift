import XCTest
import CoreData
@testable import sporty

class LeaguePresenterTests: XCTestCase {

     var mockView: MockLeaguesView!
      var mockNetwork: MockNetworkManager!
    var mockReachability: MockReachabilityManager!
    var presenter: LeaguePresenter!

    override func setUp() {
        super.setUp()
        mockView = MockLeaguesView()
        mockNetwork = MockNetworkManager()
        mockReachability = MockReachabilityManager()
        presenter = LeaguePresenter(
            view: mockView,
            sport: "football",
            networkManager: mockNetwork,
            reachability: mockReachability
        )
    }

    override func tearDown() {
        mockView = nil
        mockNetwork = nil
        mockReachability = nil
        presenter = nil
        super.tearDown()
    }

    func test_init_setsSpot() {
        XCTAssertEqual(presenter.Sport, "football")
    }

    func test_viewDidLoad_noInternet_callsShowNoInternet() {
        mockReachability.isConnected = false
        presenter.viewDidLoad()
        XCTAssertTrue(mockView.noInternetCalled)
    }

    func test_viewDidLoad_success_callsDisplayLeagues() {
        mockReachability.isConnected = true
        let league = League(leagueKey: 1, leagueName: "Premier League", countryKey: 10, countryName: "England", leagueLogo: "logo.png", countryLogo: "flag.png")
        mockNetwork.mockLeagues = [league]

        let expectation = self.expectation(description: "displayLeagues called")
        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(self.mockView.displayedNames.isEmpty)
            XCTAssertEqual(self.mockView.displayedNames.first, "Premier League")
            XCTAssertTrue(self.mockView.hideEmptyStateCalled)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_viewDidLoad_emptyLeagues_callsShowEmptyState() {
        mockReachability.isConnected = true
        mockNetwork.mockLeagues = []

        let expectation = self.expectation(description: "showEmptyState called")
        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.mockView.emptyStateMessage, "No leagues found")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_viewDidLoad_failure_callsShowEmptyState() {
        mockReachability.isConnected = true
        mockNetwork.shouldReturnError = true

        let expectation = self.expectation(description: "showEmptyState failure called")
        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.mockView.emptyStateMessage, "Failed to load leagues")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_filterLeagues_emptyText_showsAll() {
        let leagues = [
            League(leagueKey: 1, leagueName: "Premier League", countryKey: 1, countryName: "England", leagueLogo: nil, countryLogo: nil),
            League(leagueKey: 2, leagueName: "La Liga", countryKey: 2, countryName: "Spain", leagueLogo: nil, countryLogo: nil)
        ]
        presenter.setLeaguesForTesting(leagues)
        presenter.filterLeagues(with: "")
        XCTAssertEqual(mockView.displayedNames.count, 2)
    }

    func test_filterLeagues_byName_filtersCorrectly() {
        let leagues = [
            League(leagueKey: 1, leagueName: "Premier League", countryKey: 1, countryName: "England", leagueLogo: nil, countryLogo: nil),
            League(leagueKey: 2, leagueName: "La Liga", countryKey: 2, countryName: "Spain", leagueLogo: nil, countryLogo: nil)
        ]
        presenter.setLeaguesForTesting(leagues)
        presenter.filterLeagues(with: "premier")
        XCTAssertEqual(mockView.displayedNames.count, 1)
        XCTAssertEqual(mockView.displayedNames.first, "Premier League")
    }

    func test_filterLeagues_byCountry_filtersCorrectly() {
        let leagues = [
            League(leagueKey: 1, leagueName: "Premier League", countryKey: 1, countryName: "England", leagueLogo: nil, countryLogo: nil),
            League(leagueKey: 2, leagueName: "La Liga", countryKey: 2, countryName: "Spain", leagueLogo: nil, countryLogo: nil)
        ]
        presenter.setLeaguesForTesting(leagues)
        presenter.filterLeagues(with: "spain")
        XCTAssertEqual(mockView.displayedNames.count, 1)
        XCTAssertEqual(mockView.displayedNames.first, "La Liga")
    }

    func test_filterLeagues_noMatch_returnsEmpty() {
        let leagues = [
            League(leagueKey: 1, leagueName: "Premier League", countryKey: 1, countryName: "England", leagueLogo: nil, countryLogo: nil)
        ]
        presenter.setLeaguesForTesting(leagues)
        presenter.filterLeagues(with: "zzzzz")
        XCTAssertEqual(mockView.displayedNames.count, 0)
    }

    func test_toggleFavorite_outOfBounds_doesNotCrash() {
        presenter.toggleFavorite(at: 999)
        XCTAssertTrue(mockView.displayedNames.isEmpty)
    }

    func test_toggleFavorite_nilKey_doesNothing() {
        let league = League(leagueKey: nil, leagueName: "Test", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil)
        presenter.setLeaguesForTesting([league])
        presenter.toggleFavorite(at: 0)
        XCTAssertFalse(CoreDataManager.shared.isLeagueFavorite(byKey: 0))
    }

    func test_toggleFavorite_savesThenDeletes() {
        let league = League(leagueKey: 999, leagueName: "Test League", countryKey: 1, countryName: "TestCountry", leagueLogo: nil, countryLogo: nil)
        presenter.setLeaguesForTesting([league])

        presenter.toggleFavorite(at: 0)
        XCTAssertTrue(CoreDataManager.shared.isLeagueFavorite(byKey: 999))

        presenter.toggleFavorite(at: 0)
        XCTAssertFalse(CoreDataManager.shared.isLeagueFavorite(byKey: 999))
    }

    func test_didSelectLeague_validIndex_navigates() {
        let league = League(leagueKey: 42, leagueName: "Test", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil)
        presenter.setLeaguesForTesting([league])
        presenter.didSelectLeague(at: 0)
        XCTAssertEqual(mockView.navigatedLeagueId, 42)
    }

    func test_didSelectLeague_outOfBounds_doesNotNavigate() {
        presenter.didSelectLeague(at: 99)
        XCTAssertNil(mockView.navigatedLeagueId)
    }

    func test_didSelectLeague_nilKey_navigatesWithZero() {
        let league = League(leagueKey: nil, leagueName: "Test", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil)
        presenter.setLeaguesForTesting([league])
        presenter.didSelectLeague(at: 0)
        XCTAssertEqual(mockView.navigatedLeagueId, 0)
    }

    func test_updateView_nilLeagueName_usesUnknown() {
        let league = League(leagueKey: 1, leagueName: nil, countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil)
        presenter.setLeaguesForTesting([league])
        presenter.filterLeagues(with: "")
        XCTAssertEqual(mockView.displayedNames.first, "Unknown League")
        XCTAssertEqual(mockView.displayedCountries.first, "Unknown Country")
    }
}

// MARK: - Test Helper
// leagues و filteredLeagues لازم يكونوا internal (مش private) في LeaguePresenter
extension LeaguePresenter {
    func setLeaguesForTesting(_ leagues: [League]) {
        self.leagues = leagues
        self.filteredLeagues = leagues
    }
}
