import Foundation

class MainLeaguePresenter {

    weak var view: MainLeagueViewProtocol?
    private var teams: [LeagueTeam] = []
    private let leagueId: Int
    private let sport: String
    private let networkManger: NetworkManagerProtocol

    init(view: MainLeagueViewProtocol, leagueId: Int, sport: String, networkManger: NetworkManagerProtocol = NetworkManager.shared) {
        self.view = view
        self.leagueId = leagueId
        self.sport = sport
        self.networkManger = networkManger
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
        var finalFixtures: [MatchProtocol] = []
        var fetchedTeams: [LeagueTeam] = []
        var fixturesError: Error?
        var teamsError: Error?

        group.enter()

        if sport.lowercased() == "tennis" {
            networkManger.fetchTennisFixtures(leagueId: leagueId) { result in
                switch result {
                case .success(let fixtures):
                    finalFixtures = fixtures
                case .failure(let error):
                    fixturesError = error
                }
                group.leave()
            }
        } else {
            networkManger.fetchFixtures(leagueId: leagueId, sport: sport) { result in
                switch result {
                case .success(let fixtures):
                    finalFixtures = fixtures
                case .failure(let error):
                    fixturesError = error
                }
                group.leave()
            }
        }

        if sport.lowercased() != "tennis" {
            group.enter()
            networkManger.fetchTeams(leagueId: leagueId, sport: sport) { result in
                switch result {
                case .success(let teams):
                    fetchedTeams = teams
                case .failure(let error):
                    teamsError = error
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            if fixturesError != nil {
                self.view?.showEmptyState(message: "Failed to load league data")
                return
            }

            if self.sport.lowercased() != "tennis", teamsError != nil {
                self.view?.showEmptyState(message: "Failed to load teams")
                return
            }

            let upcoming = finalFixtures.filter { ($0.result ?? "").isEmpty || ($0.result ?? "") == "-" }
            let latest = finalFixtures.filter { !($0.result ?? "").isEmpty && ($0.result ?? "") != "-" }

            if self.sport.lowercased() == "tennis" {
                var extractedPlayers: [LeagueTeam] = []
                var seenPlayerNames = Set<String>()

                for fixture in finalFixtures {
                    guard let tennisFixture = fixture as? TennisFixture else { continue }

                    if let player1 = tennisFixture.title1, !player1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !seenPlayerNames.contains(player1) {
                        seenPlayerNames.insert(player1)
                        extractedPlayers.append(LeagueTeam(teamKey: tennisFixture.playerKey1, teamName: player1, teamLogo: tennisFixture.logo1))
                    }

                    if let player2 = tennisFixture.title2, !player2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !seenPlayerNames.contains(player2) {
                        seenPlayerNames.insert(player2)
                        extractedPlayers.append(LeagueTeam(teamKey: tennisFixture.playerKey2, teamName: player2, teamLogo: tennisFixture.logo2))
                    }
                }
                self.teams = extractedPlayers
            } else {
                self.teams = fetchedTeams
            }

            if upcoming.isEmpty && latest.isEmpty && self.teams.isEmpty {
                self.view?.showEmptyState(message: "No league data available")
                return
            }

            self.view?.hideEmptyState()
            self.view?.displayData(upcoming: upcoming, latest: latest, teams: self.teams)
        }
    }

    func didSelectTeam(at index: Int) {
        guard index < teams.count else { return }
        let teamId = teams[index].teamKey ?? 0
        let teamName = teams[index].teamName ?? "Unknown"
        view?.navigateToTeamDetails(with: teamId, teamName: teamName)
    }
}
