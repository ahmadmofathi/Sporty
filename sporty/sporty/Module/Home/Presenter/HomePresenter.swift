import Foundation

protocol SportsViewProtocol: AnyObject {
    func displaySports(_ names: [String], images: [String])
    func navigateToLeague(with sportName: String)
}

class HomePresenter {
    private weak var view: SportsViewProtocol?
    private let sportsNames = ["football", "BasketBall", "Tennis", "cricket"]
    private let sportsImages = ["football", "basketball", "tennis", "baseball"]
    
    init(view: SportsViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.displaySports(sportsNames, images: sportsImages)
    }
    
    func didSelectSport(at index: Int) {
        let selectedSport = sportsNames[index]
        view?.navigateToLeague(with: selectedSport)
    }
}
