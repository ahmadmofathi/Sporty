import UIKit
import SDWebImage

class LeaguesViewController: UIViewController, LeaguesViewProtocol {

    @IBOutlet var mySearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private var presenter: LeaguePresenter!
    private var leagueNames: [String] = []
    private var leagueCountries: [String] = []
    private var leagueLogos: [String] = []
    private var leagueFavorites: [Bool] = []
    var selectedSport: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues"

        tableView.delegate = self
        tableView.dataSource = self
        mySearch.delegate = self
        
        let sportToFetch = selectedSport ?? "football"
        presenter = LeaguePresenter(view: self, sport: sportToFetch)
        presenter.viewDidLoad()
    }
    
    func displayLeagues(_ names: [String], countries: [String], logos: [String], favorites: [Bool]) {
        self.leagueNames = names
        self.leagueCountries = countries
        self.leagueLogos = logos
        self.leagueFavorites = favorites
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func navigateToLeague(with leagueId: Int) {
            let ml = UIStoryboard(name: "MainLeague", bundle: nil)
            if let mainLeagueVC = ml.instantiateViewController(withIdentifier: "MainLeagueVC") as? MainLeagueViewController {
                mainLeagueVC.leagueId = leagueId
                mainLeagueVC.sportType = self.selectedSport ?? "football"
                navigationController?.pushViewController(mainLeagueVC, animated: true)
                
            }
        }
}

extension LeaguesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueCell else {
            return UITableViewCell()
        }
        
        cell.leagueNameLabel.text = leagueNames[indexPath.row]
        cell.countryLabel.text = leagueCountries[indexPath.row]
        let isFav = leagueFavorites[indexPath.row]
        let heartImage = isFav ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        cell.favoriteButton.setImage(heartImage, for: .normal)
        cell.onFavoriteTapped = { [weak self] in
            self?.presenter.toggleFavorite(at: indexPath.row)
        }
        
        let defaultPlaceholder = UIImage(named: "league_placeholder")
        let logoURLString = leagueLogos[indexPath.row]
        
        if let url = URL(string: logoURLString), !logoURLString.isEmpty {
            cell.logoImageView.sd_setImage(
                with: url,
                placeholderImage: defaultPlaceholder,
                options: [.retryFailed, .continueInBackground]
            )
        } else {
            cell.logoImageView.image = defaultPlaceholder
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let leagueCell = cell as? LeagueCell {
            leagueCell.startFlashying()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectLeague(at: indexPath.row)
    }
}

extension LeaguesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterLeagues(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        presenter.filterLeagues(with: "")
    }
}
