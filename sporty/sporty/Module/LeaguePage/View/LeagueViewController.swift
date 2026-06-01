//
//  LeaguesViewController.swift
//  sporty
//
//  Created by Shady Ramadan on 25/05/2026.
//

import UIKit
import SDWebImage
protocol LeaguesViewProtocol: AnyObject {
    func displayLeagues(_ names: [String], countries: [String], logos: [String])
    func navigateToLeague(with leagueName: String)
}

class LeaguesViewController: UIViewController, LeaguesViewProtocol {

    @IBOutlet weak var tableView: UITableView!

    private var presenter: LeaguePresenter!
    private var leagueNames: [String] = []
    private var leagueCountries: [String] = []
    private var leagueLogos: [String] = []
    var selectedSport : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues"

        tableView.delegate = self
        tableView.dataSource = self
        let sportToFetch = selectedSport ?? "football"
        presenter = LeaguePresenter(view: self, sport : sportToFetch)
        presenter.viewDidLoad()
    }
    
    func displayLeagues(_ names: [String], countries: [String], logos: [String]) {
        self.leagueNames = names
        self.leagueCountries = countries
        self.leagueLogos = logos
        
        // التحديث على الـ Main Thread لأن الـ API شغال في الخلفية
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func navigateToLeague(with leagueName: String) {
        let ml = UIStoryboard(name: "MainLeague", bundle: nil)
        if let MainLeagueVC = ml.instantiateViewController(withIdentifier: "MainLeagueVC") as? MainLeagueViewController{
            self.navigationController?.pushViewController(MainLeagueVC, animated: true)
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
        
        let name = leagueNames[indexPath.row]
        let country = leagueCountries[indexPath.row]
        let logoURLString = leagueLogos[indexPath.row]
        
        cell.leagueNameLabel.text = name
        cell.countryLabel.text = country
        
        let defaultPlaceholder = UIImage(named: "league_placeholder")
        
        if let url = URL(string: logoURLString), !logoURLString.isEmpty {
            cell.logoImageView.sd_setImage(
                with: url,
                placeholderImage: defaultPlaceholder,
                options: [.retryFailed, .continueInBackground]    )
        } else {
               cell.logoImageView.image = defaultPlaceholder
        }
        
        return cell
    }
    
    // الأنميشن مكانه الصح هنا عشان الـ Cell تكون ظهرت بالـ Frames المظبوطة
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
