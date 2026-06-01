//
//  LeaguePresenter.swift
//  sporty
//
//  Created by Shady Ramadan on 01/06/2026.
//

import Foundation
class LeaguePresenter {
    private weak var view: LeaguesViewProtocol?
    private let leagues: [(name: String, country: String)] = [
        ("Premier League", "England"),
        ("La Liga", "Spain"),
        ("Serie A", "Italy"),
        ("Bundesliga", "Germany"),
        ("Ligue 1", "France"),
        ("Egyptian League", "Egypt")
    ]
    
    init(view: LeaguesViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        let names = leagues.map { $0.name }
        let countries = leagues.map { $0.country }
        view?.displayLeagues(names, countries: countries)
    }
    
    func didSelectLeague(at index: Int) {
        let selectedLeague = leagues[index].name
        view?.navigateToLeague(with: selectedLeague)
    }
}
