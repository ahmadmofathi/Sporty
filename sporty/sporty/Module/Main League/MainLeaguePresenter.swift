//
//  MainLeaguePresenter.swift
//  sporty
//
//  Created by Shady Ramadan on 01/06/2026.
//

import Foundation

class MainLeaguePresenter {
    private weak var view: MainLeagueViewProtocol?
    
    private let upcomingEvents = [
        (team1: "Liverpool", team2: "Arsenal", score: "2 - 1", week: "Week 30"),
        (team1: "Chelsea", team2: "Man City", score: "1 - 3", week: "Week 30"),
        (team1: "Man United", team2: "Tottenham", score: "0 - 0", week: "Week 30")
    ]

    private let teams = [
        "Liverpool", "Arsenal", "Chelsea", "Man City", "Man United", "Tottenham"
    ]
    
    init(view: MainLeagueViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.displayData(upcoming: upcomingEvents, teams: teams)
    }
    
    func didSelectTeam(at index: Int) {
        let selectedTeam = teams[index]
        view?.navigateToTeamDetails(with: selectedTeam)
    }
}
