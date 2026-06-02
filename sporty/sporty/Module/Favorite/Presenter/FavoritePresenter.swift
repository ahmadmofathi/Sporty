//
//  FavoritePresenter.swift
//  sporty
//
//  Created by Shady Ramadan on 02/06/2026.
//

import Foundation

protocol FavoritesViewProtocol: AnyObject {
    func displayFavorites(_ leagues: [League])
    func navigateToLeague(with leagueName: String)
    func showDeleteConfirmationAlert(leagueName: String, confirmHandler: @escaping () -> Void)
}

class FavoritesPresenter {
    private weak var view: FavoritesViewProtocol?
    private var favoriteLeagues: [League] = []
    
    init(view: FavoritesViewProtocol) {
        self.view = view
    }
    
      func viewWillAppear() {
        fetchFavoritesFromCoreData()
    }
    
    func fetchFavoritesFromCoreData() {
        self.favoriteLeagues = CoreDataManager.shared.fetchAllFavorites()
        self.view?.displayFavorites(favoriteLeagues)
    }
    
    func getFavoritesCount() -> Int {
        return favoriteLeagues.count
    }
    
    func getFavoriteLeague(at index: Int) -> League? {
        guard index < favoriteLeagues.count else { return nil }
        return favoriteLeagues[index]
    }
    
    func didSelectRow(at index: Int) {
    
        if index < favoriteLeagues.count {
            let selectedLeagueName = favoriteLeagues[index].leagueName ?? ""
            view?.navigateToLeague(with: selectedLeagueName)
        }
    }
    
    func requestDeleteLeague(at index: Int) {
        guard index < favoriteLeagues.count else { return }
        let league = favoriteLeagues[index]
        let name = league.leagueName ?? "Unknown League"
        
    view?.showDeleteConfirmationAlert(leagueName: name) { [weak self] in
            guard let self = self, let key = league.leagueKey else { return }
            
                 CoreDataManager.shared.deleteLeague(byKey: key)
            self.fetchFavoritesFromCoreData()
        }
    }
}
