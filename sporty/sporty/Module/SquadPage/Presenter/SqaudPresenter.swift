import Foundation

protocol SquadPresenterProtocol {
    var players: [Player] { get }
    func getPlayers(teamId: Int)
}

class SquadPresenter: SquadPresenterProtocol {
    private weak var view: SquadViewProtocol?
    var players: [Player] = []

    init(view: SquadViewProtocol) {
        self.view = view
    }

    func getPlayers(teamId: Int) {
       NetworkManager.shared.fetchPlayers(teamId: teamId) { [weak self] result in
            switch result {
            case .success(let fetchedPlayers):
                self?.players = fetchedPlayers
                
                       print("✅ Successfully fetched \(fetchedPlayers.count) players")
                if let firstPlayer = fetchedPlayers.first {
                    print("👤 First Player Name: \(firstPlayer.playerName ?? "Nil")")
                }
                
                // بنرجع للـ Main Thread عشان نحدث الـ TableView
                DispatchQueue.main.async {
                    self?.view?.renderPlayers()
                }
            case .failure(let error):
                print("❌ Network Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
