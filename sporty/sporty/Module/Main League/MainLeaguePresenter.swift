import Foundation

class MainLeaguePresenter {
    weak var view: MainLeagueViewProtocol?
    private var teams: [LeagueTeam] = []
    private let leagueId: Int
    
    var leagueName: String {
        switch leagueId {
        case 34: return "English Premier League"
        case 152: return "La Liga"
        case 168: return "Serie A"
        default: return "League Details"
        }
    }

    init(view: MainLeagueViewProtocol, leagueId: Int) {
        self.view = view
        self.leagueId = leagueId
    }

    func viewDidLoad() {
        loadData()
    }

    private func loadData() {
        let group = DispatchGroup()
        var fetchedFixtures: [Fixture] = []
        var fetchedTeams: [LeagueTeam] = []

        group.enter()
        NetworkManager.shared.fetchFixtures(leagueId: leagueId) { result in
            if case .success(let fixtures) = result { fetchedFixtures = fixtures }
            group.leave()
        }

        group.enter()
        NetworkManager.shared.fetchTeams(leagueId: leagueId) { result in
            if case .success(let teams) = result { fetchedTeams = teams }
            group.leave()
        }

        group.notify(queue: .main) {
            self.teams = fetchedTeams
            self.view?.setLeagueName(self.leagueName)
            
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
