//
//  SqaudPresenter.swift
//  sporty
//
//  Created by Ahmad on 01/06/2026.
//

import Foundation

class SquadPresenter: SquadPresenterProtocol {

    weak var view: SquadViewProtocol?

    var players: [Player] = []

    init(view: SquadViewProtocol) {
        self.view = view
    }

    func getPlayers(teamId: Int) {

        NetworkManager.shared.fetchPlayers(
            teamId: teamId
        ) { [weak self] result in

            switch result {

            case .success(let players):

                self?.players = players

                DispatchQueue.main.async {
                    self?.view?.renderPlayers()
                }

            case .failure(let error):

                DispatchQueue.main.async {
                    self?.view?.showError(
                        message: error.localizedDescription
                    )
                }
            }
        }
    }
}
