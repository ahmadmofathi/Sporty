//
//  LeagueViewController.swift
//  sporty
//
//  Created by Shady Ramadan on 25/05/2026.
//

import UIKit

protocol LeaguesViewProtocol: AnyObject {
    func displayLeagues(_ names: [String], countries: [String])
    func navigateToLeague(with leagueName: String)
}

class LeaguesViewController: UIViewController, LeaguesViewProtocol {

    @IBOutlet weak var tableView: UITableView!

    private var presenter: LeaguePresenter!
    private var leagueNames: [String] = []
    private var leagueCountries: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues"

        tableView.delegate = self
        tableView.dataSource = self
        
        presenter = LeaguePresenter(view: self)
        presenter.viewDidLoad()
    }
    
    func displayLeagues(_ names: [String], countries: [String]) {
        self.leagueNames = names
        self.leagueCountries = countries
        self.tableView.reloadData()
    }
    
    func navigateToLeague(with leagueName: String) {
        if let MainLeagueVC = storyboard?.instantiateViewController(withIdentifier: "MainLeagueVC") {
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
        
        cell.startFlashying()
        
        let name = leagueNames[indexPath.row]
        let country = leagueCountries[indexPath.row]
        
        cell.leagueNameLabel.text = name
        cell.countryLabel.text = country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectLeague(at: indexPath.row)
    }
}
