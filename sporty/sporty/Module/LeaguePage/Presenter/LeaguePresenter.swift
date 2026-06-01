//
//  LeaguePresenter.swift
//  sporty
//
//  Created by Shady Ramadan on 01/06/2026.
//

import Foundation

class LeaguePresenter {
    private weak var view: LeaguesViewProtocol?
   
    private var leagues: [League] = []
    var Sport : String?
    
    init(view: LeaguesViewProtocol, sport : String) {
        self.view = view
        self.Sport = sport
    }
    
    func viewDidLoad() {
       
        NetworkManager.shared.fetchLeagues(sport: self.Sport! ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedLeagues):
                self.leagues = fetchedLeagues
                
    
                let names = fetchedLeagues.map { $0.leagueName ?? "Unknown League" }
                let countries = fetchedLeagues.map { $0.countryName ?? "Unknown Country" }
                let logos = fetchedLeagues.map { $0.leagueLogo ?? "" }
                
                self.view?.displayLeagues(names, countries: countries, logos: logos)
                
            case .failure(let error):
                print("Error loading leagues: \(error.localizedDescription)")
                    }
        }
    }
    
    func didSelectLeague(at index: Int) {
        guard index < leagues.count else { return }
        let selectedLeague = leagues[index].leagueName ?? ""
        view?.navigateToLeague(with: selectedLeague)
    }
}
