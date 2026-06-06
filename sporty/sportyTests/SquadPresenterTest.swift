
import XCTest
@testable import sporty

class MockSquadView: SquadViewProtocol {
    var showNoInternetCalled = false
    var showEmptyStateCalled = false
    var hideEmptyStateCalled = false
    var renderPlayersCalled = false
    var showErrorCalled = false
    var lastErrorMessage: String?
    var lastEmptyMessage: String?
    
    func showNoInternet() { showNoInternetCalled = true }
    func showEmptyState(message: String) { showEmptyStateCalled = true; lastEmptyMessage = message }
    func hideEmptyState() { hideEmptyStateCalled = true }
    func renderPlayers() { renderPlayersCalled = true }
    func showError(message: String) { showErrorCalled = true; lastErrorMessage = message }
}
class SquadPresenterTests: XCTestCase {
    var presenter: SquadPresenter!
    var mockView: MockSquadView!
    var mockNetwork: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockView = MockSquadView()
        mockNetwork = MockNetworkManager()
        presenter = SquadPresenter(view: mockView, sport: "football", networkManger: mockNetwork)
        
        }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func testGetPlayersSuccessWithData() {
        let jsonData = #"{"player_key": 1, "player_name": "Shady"}"#.data(using: .utf8)!
        let dummyPlayer = try! JSONDecoder().decode(Player.self, from: jsonData)
        mockNetwork.mockPlayers = [dummyPlayer]
        let expectation = self.expectation(description: "Wait for dispatch queue main async")
        presenter.getPlayers(teamId: 10)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            XCTAssertEqual(self.presenter.players.count, 1)
            XCTAssertTrue(self.mockView.hideEmptyStateCalled)
            XCTAssertTrue(self.mockView.renderPlayersCalled)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.5)
    }
    
    func testGetPlayersSuccessWithEmptyData() {
        mockNetwork.mockPlayers = []
        let expectation = self.expectation(description: "Wait for empty state async")
       presenter.getPlayers(teamId: 10)
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            XCTAssertTrue(self.presenter.players.isEmpty)
            XCTAssertTrue(self.mockView.showEmptyStateCalled)
            XCTAssertEqual(self.mockView.lastEmptyMessage, "No players found")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.5)
    }
    
    func testGetPlayersFailure() {
           mockNetwork.shouldReturnError = true
        let expectation = self.expectation(description: "Wait for error block async")
        
            presenter.getPlayers(teamId: 10)
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            XCTAssertTrue(self.mockView.showErrorCalled)
            XCTAssertNotNil(self.mockView.lastErrorMessage)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.5)
    }
}
