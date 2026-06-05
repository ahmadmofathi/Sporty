import Foundation

class MainLeaguePresenter {

    weak var view: MainLeagueViewProtocol?

    private var teams: [LeagueTeam] = []

    private let leagueId: Int
    private let sport: String

    init(
        view: MainLeagueViewProtocol,
        leagueId: Int,
        sport: String
    ) {
        self.view = view
        self.leagueId = leagueId
        self.sport = sport
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    private func loadData() {

        guard ReachabilityManager.shared.isConnected else {

            DispatchQueue.main.async {

                self.view?.showNoInternet()
            }

            return
        }

        let group = DispatchGroup()

        var fetchedFixtures: [Fixture] = []
        var fetchedTeams: [LeagueTeam] = []

        var fixturesError: Error?
        var teamsError: Error?

        group.enter()

        NetworkManager.shared.fetchFixtures(
            leagueId: leagueId,
            sport: sport
        ) { result in

            switch result {

            case .success(let fixtures):
                fetchedFixtures = fixtures

            case .failure(let error):
                fixturesError = error
            }

            group.leave()
        }

        group.enter()

        NetworkManager.shared.fetchTeams(
            leagueId: leagueId,
            sport: sport
        ) { result in

            switch result {

            case .success(let teams):
                fetchedTeams = teams

            case .failure(let error):
                teamsError = error
            }

            group.leave()
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
