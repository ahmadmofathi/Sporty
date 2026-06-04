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

            if fixturesError != nil || teamsError != nil {

                self.view?.showEmptyState(
                    message: "Failed to load league data"
                )

                return
            }

            self.teams = fetchedTeams

            let upcoming = fetchedFixtures.filter {
                $0.isUpcoming
            }

            let latest = fetchedFixtures.filter {
                !$0.isUpcoming
            }

            if upcoming.isEmpty &&
                latest.isEmpty &&
                fetchedTeams.isEmpty {

                self.view?.showEmptyState(
                    message: "No league data available"
                )

                return
            }

            self.view?.hideEmptyState()

            self.view?.displayData(
                upcoming: upcoming,
                latest: latest,
                teams: fetchedTeams
            )
        }
    }

    func didSelectTeam(at index: Int) {

        guard index < teams.count else {
            return
        }

        let teamId =
        teams[index].teamKey ?? 0

        view?.navigateToTeamDetails(
            with: teamId
        )
    }
}
