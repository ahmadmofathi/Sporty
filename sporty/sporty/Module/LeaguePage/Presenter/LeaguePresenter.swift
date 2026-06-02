//
//  LeaguePresenter.swift
//  sporty
//
//  Created by Shady Ramadan on 01/06/2026.
//

import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func displayLeagues(_ names: [String], countries: [String], logos: [String], favorites: [Bool])
    func navigateToLeague(with leagueName: String)
}

class LeaguePresenter {
    private weak var view: LeaguesViewProtocol?
    private var leagues: [League] = []
    var Sport: String?
    
    init(view: LeaguesViewProtocol, sport: String) {
        self.view = view
        self.Sport = sport
    }
    
    func viewDidLoad() {
        NetworkManager.shared.fetchLeagues(sport: self.Sport!) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedLeagues):
                self.leagues = fetchedLeagues
                self.updateView()
            case .failure(let error):
                print("Error loading leagues: \(error.localizedDescription)")
            }
        }
    }
    
    func toggleFavorite(at index: Int) {
        guard index < leagues.count else { return }
        let league = leagues[index]
        guard let key = league.leagueKey else { return }
        
        if CoreDataManager.shared.isLeagueFavorite(byKey: key) {
            CoreDataManager.shared.deleteLeague(byKey: key)
        } else {
            CoreDataManager.shared.saveLeague(league, sport: self.Sport ?? "football")
        }
        updateView()
    }
    
    private func updateView() {
        let names = leagues.map { $0.leagueName ?? "Unknown League" }
        let countries = leagues.map { $0.countryName ?? "Unknown Country" }
        let logos = leagues.map { $0.leagueLogo ?? "" }
        let favorites = leagues.map { CoreDataManager.shared.isLeagueFavorite(byKey: $0.leagueKey ?? 0) }
        
        self.view?.displayLeagues(names, countries: countries, logos: logos, favorites: favorites)
    }
    
    func didSelectLeague(at index: Int) {
        guard index < leagues.count else { return }
        let selectedLeague = leagues[index].leagueName ?? ""
        view?.navigateToLeague(with: selectedLeague)
    }
}
