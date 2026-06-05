import Foundation

class MainLeaguePresenter {
    weak var view: MainLeagueViewProtocol?
    private var teams: [LeagueTeam] = []
    private let leagueId: Int
    private let sport: String
    
    init(view: MainLeagueViewProtocol, leagueId: Int, sport: String) {
        self.view = view
        self.leagueId = leagueId
        self.sport = sport
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    private func loadData() {
        let group = DispatchGroup()
        var finalFixtures: [MatchProtocol] = []
        var fetchedTeams: [LeagueTeam] = []
        
        group.enter()
        if sport.lowercased() == "tennis" {
            NetworkManager.shared.fetchTennisFixtures(leagueId: leagueId) { result in
                if case .success(let data) = result { finalFixtures = data }
                group.leave()
            }
        } else {
            NetworkManager.shared.fetchFixtures(leagueId: leagueId, sport: sport) { result in
                if case .success(let data) = result { finalFixtures = data }
                group.leave()
            }
        }
        
        if sport.lowercased() != "tennis" {
            group.enter()
            NetworkManager.shared.fetchTeams(leagueId: leagueId, sport: sport) { result in
                if case .success(let teams) = result { fetchedTeams = teams }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            let upcoming = finalFixtures.filter { ($0.result ?? "").isEmpty || ($0.result ?? "") == "-" }
            let latest = finalFixtures.filter { !($0.result ?? "").isEmpty && ($0.result ?? "") != "-" }
            
            if self.sport.lowercased() == "tennis" {
                var extractedPlayers: [LeagueTeam] = []
                var seenPlayerNames = Set<String>()
                
                for fixture in finalFixtures {
                    print("🔍 Fixture type: \(type(of: fixture)) | Title: \(fixture.title1 ?? "")")
                    
                    if let tennisFixture = fixture as? TennisFixture {
                        print("✅ Successfully casted to TennisFixture!")
                        if let p1 = tennisFixture.title1, !p1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !seenPlayerNames.contains(p1) {
                            seenPlayerNames.insert(p1)
                            
                            let p1Key = tennisFixture.playerKey1
                            print("🎯 Extracted Player 1 Key: \(String(describing: p1Key))")
                            
                            let playerAsTeam = LeagueTeam(teamKey: p1Key, teamName: p1, teamLogo: tennisFixture.logo1)
                            extractedPlayers.append(playerAsTeam)
                        }
                        
                        if let p2 = tennisFixture.title2, !p2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !seenPlayerNames.contains(p2) {
                            seenPlayerNames.insert(p2)
                            
                            let p2Key = tennisFixture.playerKey2
                            
                            let playerAsTeam = LeagueTeam(teamKey: p2Key, teamName: p2, teamLogo: tennisFixture.logo2)
                            extractedPlayers.append(playerAsTeam)
                        }
                    } else {
                        print("❌ Failed to cast to TennisFixture!")
                    }
                }
                self.teams = extractedPlayers
                
            } else {
                self.teams = fetchedTeams
            }
            
            self.view?.displayData(upcoming: upcoming, latest: latest, teams: self.teams)
        }
    }
}
