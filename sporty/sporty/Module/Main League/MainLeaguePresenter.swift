import Foundation

class MainLeaguePresenter {

    weak var view: MainLeagueViewProtocol?

    private var teams: [LeagueTeam] = []

    private let leagueId: Int

    init(
        view: MainLeagueViewProtocol,
        leagueId: Int
    ) {

        self.view = view
        self.leagueId = leagueId
    }

    func viewDidLoad() {

        loadData()
    }

    private func loadData() {

        NetworkManager.shared.fetchFixtures(
            leagueId: leagueId
        ) { [weak self] fixturesResult in

            guard let self else { return }

            NetworkManager.shared.fetchTeams(
                leagueId: self.leagueId
            ) { teamsResult in

                switch (fixturesResult, teamsResult) {

                case (.success(let fixtures),
                      .success(let teams)):

                    self.teams = teams
                    print(teams,fixtures)
                    DispatchQueue.main.async {

                        self.view?.displayData(
                            upcoming: fixtures, latest: fixtures,
                            teams: teams
                        )
                    }

                case (.failure(let error), _):
                    print(error.localizedDescription)

                case (_, .failure(let error)):
                    print(error.localizedDescription)
                }
            }
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
