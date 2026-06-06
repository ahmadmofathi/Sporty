import XCTest
@testable import sporty

class MockTennisPlayerView: TennisPlayerViewProtocol {
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var displayPlayerProfileCalled = false
    var reloadStatsTableCalled = false
    var showErrorCalled = false
    var lastErrorMessage: String?
    
    func showLoading() { showLoadingCalled = true }
    func hideLoading() { hideLoadingCalled = true }
    func displayPlayerProfile(_ profile: TennisPlayerProfile) { displayPlayerProfileCalled = true }
    func reloadStatsTable() { reloadStatsTableCalled = true }
    func showError(message: String) { showErrorCalled = true; lastErrorMessage = message }
}

class TennisPlayerPresenterTests: XCTestCase {
    var presenter: TennisPlayerPresenter!
    var mockView: MockTennisPlayerView!
    var mockNetwork: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockView = MockTennisPlayerView()
        mockNetwork = MockNetworkManager()
        presenter = TennisPlayerPresenter(view: mockView, networkManger: mockNetwork)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func testFetchPlayerDetailsSuccess() {
        let jsonString = """
        {
            "player_key": 123,
            "player_name": "Test Player",
            "stats": [
                {"year": "2021", "rank": "15", "titles": "2"},
                {"year": "2019", "rank": "8", "titles": "4"}
            ]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let dummyProfile = try! JSONDecoder().decode(TennisPlayerProfile.self, from: jsonData)
        
        mockNetwork.mockPlayerProfile = dummyProfile
        
        presenter.fetchPlayerDetails(playerKey: 123)
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.displayPlayerProfileCalled)
        XCTAssertEqual(presenter.getBestRank(), "#8")
        XCTAssertEqual(presenter.getProSince(), "-")
        XCTAssertEqual(presenter.getTotalTitles(), "6")
        
        XCTAssertEqual(presenter.getNumberOfRows(for: 0), 2)
        XCTAssertNotNil(presenter.getStat(at: 0))
    }
    
    func testFetchPlayerDetailsFailure() {
        mockNetwork.shouldReturnError = true
        presenter.fetchPlayerDetails(playerKey: 123)
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertNotNil(mockView.lastErrorMessage)
    }
    
    func testGetTournamentIndexOutOfBoundsReturnsNil() {
        XCTAssertNil(presenter.getTournament(at: 999))
    }
}
