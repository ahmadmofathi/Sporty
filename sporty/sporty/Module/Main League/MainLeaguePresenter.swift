import Foundation

class MainLeaguePresenter {
    private weak var view: MainLeagueViewProtocol?
    
    private let upcomingEvents = [
        (team1: "Liverpool", team2: "Arsenal", score: "2 - 1", week: "Week 30"),
        (team1: "Chelsea", team2: "Man City", score: "1 - 3", week: "Week 30"),
        (team1: "Man United", team2: "Tottenham", score: "0 - 0", week: "Week 30")
    ]

      private let teams: [(name: String, id: Int)] = [
        (name: "Liverpool", id: 86),
        (name: "Arsenal", id: 96),
        (name: "Chelsea", id: 102),
        (name: "Man City", id: 95),
        (name: "Man United", id: 101),
        (name: "Tottenham", id: 110)
    ]
    
    init(view: MainLeagueViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
              let teamNames = teams.map { $0.name }
        view?.displayData(upcoming: upcomingEvents, teams: teamNames)
    }
    
    func didSelectTeam(at index: Int) {
           let selectedTeamId = teams[index].id
         view?.navigateToTeamDetails(with: selectedTeamId)
    }
}
