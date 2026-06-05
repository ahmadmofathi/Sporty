import Foundation

protocol SquadPresenterProtocol {

    var players: [Player] { get }

    func getPlayers(teamId: Int)
}

class SquadPresenter: SquadPresenterProtocol {

    private weak var view: SquadViewProtocol?

    var players: [Player] = []

    private let sport: String

    init(
        view: SquadViewProtocol,
        sport: String
    ) {

        self.view = view
        self.sport = sport
    }

    func getPlayers(teamId: Int) {

        guard ReachabilityManager.shared.isConnected else {

            DispatchQueue.main.async {

                self.view?.showNoInternet()
            }

            return
        }

        NetworkManager.shared.fetchPlayers(
            teamId: teamId,
            sport: self.sport
        ) { [weak self] result in

            guard let self = self else {
                return
            }

            switch result {

            case .success(let fetchedPlayers):

                self.players = fetchedPlayers

                print(
                    "✅ Successfully fetched \(fetchedPlayers.count) players"
                )

                DispatchQueue.main.async {

                    if fetchedPlayers.isEmpty {

                        self.view?.showEmptyState(
                            message: "No players found"
                        )

                    } else {

                        self.view?.hideEmptyState()
                        self.view?.renderPlayers()
                    }
                }

            case .failure(let error):

                print(
                    "❌ Network Error: \(error.localizedDescription)"
                )

                DispatchQueue.main.async {

                    self.view?.showError(
                        message: error.localizedDescription
                    )
                }
            }
        }
    }
}
