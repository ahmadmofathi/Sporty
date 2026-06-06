import XCTest
@testable import sporty

class NetworkManagerIntegrationTests: XCTestCase {
    
    var sut: NetworkManager!
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetchLeagues_football_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Leagues Football")
        
        sut.fetchLeagues(sport: "football") { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
            case .failure(let error):
                XCTFail("Football Leagues Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchLeagues_basketball_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Leagues Basketball")
        
        sut.fetchLeagues(sport: "basketball") { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
            case .failure(let error):
                XCTFail("Basketball Leagues Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchLeagues_cricket_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Leagues Cricket")
        
        sut.fetchLeagues(sport: "cricket") { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
            case .failure(let error):
                XCTFail("Cricket Leagues Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchLeagues_tennis_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Leagues Tennis")
        
        sut.fetchLeagues(sport: "tennis") { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
            case .failure(let error):
                XCTFail("Tennis Leagues Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchTeams_football_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Teams Football")
        
        sut.fetchTeams(leagueId: 152, sport: "football") { result in
            switch result {
            case .success(let teams):
                XCTAssertNotNil(teams)
            case .failure(let error):
                XCTFail("Football Teams Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchTeams_basketball_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Teams Basketball")
        
        sut.fetchTeams(leagueId: 771, sport: "basketball") { result in
            switch result {
            case .success(let teams):
                XCTAssertNotNil(teams)
            case .failure(let error):
                XCTFail("Basketball Teams Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchFixtures_football_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Fixtures Football")
        
        sut.fetchFixtures(leagueId: 152, sport: "football") { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures)
            case .failure(let error):
                XCTFail("Football Fixtures Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchFixtures_basketball_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Fixtures Basketball")
        
        sut.fetchFixtures(leagueId: 771, sport: "basketball") { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures)
            case .failure(let error):
                XCTFail("Basketball Fixtures Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchPlayers_football_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Players Football")
        
        sut.fetchPlayers(teamId: 96, sport: "football") { result in
            switch result {
            case .success(let players):
                XCTAssertNotNil(players)
            case .failure(let error):
                XCTFail("Football Players Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchTennisFixtures_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Tennis Fixtures")
        
        sut.fetchTennisFixtures(leagueId: 2045) { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures)
            case .failure(let error):
                XCTFail("Tennis Fixtures Failed: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchPlayerProfile_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Player Profile")
        
        sut.fetchPlayerProfile(with: 200) { result in
            switch result {
            case .success(let profile):
                XCTAssertNotNil(profile)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchPlayerTournaments_withRealNetwork() {
        let expectation = self.expectation(description: "Fetch Player Tournaments")
        
        sut.fetchPlayerTournaments(playerKey: 200) { result in
            switch result {
            case .success(let tournaments):
                XCTAssertNotNil(tournaments)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchLeagues_invalidSport_handlesResult() {
        let expectation = self.expectation(description: "Fetch Leagues Invalid Sport")
        
        sut.fetchLeagues(sport: "invalidSportName") { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchTeams_invalidLeague_handlesResult() {
        let expectation = self.expectation(description: "Fetch Teams Invalid League")
        
        sut.fetchTeams(leagueId: -1, sport: "football") { result in
            switch result {
            case .success(let teams):
                XCTAssertNotNil(teams)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func test_fetchFixtures_invalidLeague_handlesResult() {
        let expectation = self.expectation(description: "Fetch Fixtures Invalid League")
        
        sut.fetchFixtures(leagueId: -1, sport: "football") { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20.0, handler: nil)
    }
}
