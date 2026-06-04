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
        var fetchedFixtures: [Fixture] = []
        var fetchedTeams: [LeagueTeam] = []

        group.enter()
        NetworkManager.shared.fetchFixtures(leagueId: leagueId, sport: sport) { result in
            if case .success(let fixtures) = result { fetchedFixtures = fixtures }
            group.leave()
        }

        group.enter()
        NetworkManager.shared.fetchTeams(leagueId: leagueId, sport: sport) { result in
            if case .success(let teams) = result { fetchedTeams = teams }
            group.leave()
        }

        group.notify(queue: .main) {
            self.teams = fetchedTeams
            let upcoming = fetchedFixtures.filter { $0.isUpcoming }
            let latest = fetchedFixtures.filter { !$0.isUpcoming }
            self.view?.displayData(upcoming: upcoming, latest: latest, teams: fetchedTeams)
        }
    }
    func didSelectTeam(at index: Int) {
        guard index < teams.count else { return }
        let teamId = teams[index].teamKey ?? 0
        view?.navigateToTeamDetails(with: teamId)
    }
}
