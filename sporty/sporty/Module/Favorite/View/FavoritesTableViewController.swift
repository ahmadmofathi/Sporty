import UIKit
import SDWebImage

class FavoritesTableViewController: UITableViewController, FavoritesViewProtocol {
    
    private var presenter: FavoritesPresenter!
    private var favoriteLeagues: [League] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = 92
        presenter = FavoritesPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // تصحيح لـ super.viewWillAppear
        presenter.viewWillAppear()
    }
    
    func displayFavorites(_ leagues: [League]) {
        self.favoriteLeagues = leagues
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // الميثود المحدثة لاستقبال الـ id
    func navigateToLeague(with leagueId: Int) {
        let ml = UIStoryboard(name: "MainLeague", bundle: nil)
        if let mainLeagueVC = ml.instantiateViewController(withIdentifier: "MainLeagueVC") as? MainLeagueViewController {
            
            // تمرير الـ id للشاشة اللي رايح لها
            mainLeagueVC.leagueId = leagueId
            
            self.navigationController?.pushViewController(mainLeagueVC, animated: true)
        }
    }
    
    func showDeleteConfirmationAlert(leagueName: String, confirmHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Remove From Favorites",
            message: "Are you sure you want to remove \(leagueName) from your favorites?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in confirmHandler() })
        
        present(alert, animated: true)
    }
    
    // ... باقي الـ TableView Delegate methods (cellForRowAt, didSelectRowAt, etc)
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLeagues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoriteTableViewCell
        let league = favoriteLeagues[indexPath.row]
        
        cell.favTitle.text = league.leagueName ?? "Unknown League"
        cell.favOrigin.text = league.countryName ?? "Unknown Country"
        
        cell.favImg.layer.cornerRadius = 28
        cell.favImg.clipsToBounds = true
        
        let defaultPlaceholder = UIImage(named: "Placeholder")
        if let logoURLString = league.leagueLogo, let url = URL(string: logoURLString), !logoURLString.isEmpty {
            cell.favImg.sd_setImage(with: url, placeholderImage: defaultPlaceholder)
        } else {
            cell.favImg.image = defaultPlaceholder
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.requestDeleteLeague(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath.row)
    }
    
}
