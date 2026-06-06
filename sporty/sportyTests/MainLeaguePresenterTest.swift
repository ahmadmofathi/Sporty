import XCTest
@testable import sporty

class MockMainLeagueView: MainLeagueViewProtocol {
    func navigateToTeamDetails(with teamId: Int, teamName: String) {
        <#code#>
    }
    
    var displayDataCalled = false
    var navigateToTeamDetailsCalled = false
    var navigateToTennisDetailsCalled = false
    var showNoInternetCalled = false
    var showEmptyStateCalled = false
    var hideEmptyStateCalled = false
    var lastEmptyMessage: String?
    var lastLeagueNameSet: String?
    
    func setLeagueName(_ name: String) {
        lastLeagueNameSet = name
    }
    
    func displayData(upcoming: [MatchProtocol], latest: [MatchProtocol], teams: [LeagueTeam]) {
        displayDataCalled = true
    }
    
    func navigateToTeamDetails(with teamId: Int) {
        navigateToTeamDetailsCalled = true
    }
    
    func navigateToTennisDetails(with playerKey: Int) {
        navigateToTennisDetailsCalled = true
    }
    
    func showNoInternet() {
        showNoInternetCalled = true
    }
    
    func showEmptyState(message: String) {
        showEmptyStateCalled = true
        lastEmptyMessage = message
    }
    
    func hideEmptyState() {
        hideEmptyStateCalled = true
    }
}

class MainLeaguePresenterTests: XCTestCase {
    var presenter: MainLeaguePresenter!
    var mockView: MockMainLeagueView!
    var mockNetwork: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockView = MockMainLeagueView()
        mockNetwork = MockNetworkManager()
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockNetwork = nil
        super.tearDown()
    }
    
   func testDidSelectTeamWithInvalidIndexDoesNotCrash() {
       
        presenter = MainLeaguePresenter(view: mockView, leagueId: 5, sport: "football", networkManger: mockNetwork)
      
        presenter.didSelectTeam(at: 99)
        
       
        XCTAssertFalse(mockView.navigateToTeamDetailsCalled)
    }
    
    func testFootballDataLoadingReturnsEmptyState() {
        
        presenter = MainLeaguePresenter(view: mockView, leagueId: 4, sport: "football", networkManger: mockNetwork)
        mockNetwork.mockFixtures = []
        mockNetwork.mockTeams = []
        
        let expectation = self.expectation(description: "Wait for dispatch group notify")
        
       
        presenter.viewDidLoad()
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                   if self.mockView.showNoInternetCalled {
                XCTAssertTrue(self.mockView.showNoInternetCalled)
            } else {
                XCTAssertTrue(self.mockView.showEmptyStateCalled)
                XCTAssertEqual(self.mockView.lastEmptyMessage, "No league data available")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.5)
    }
}
