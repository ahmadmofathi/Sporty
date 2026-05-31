//
//  LeagueViewController.swift
//  sporty
//
//  Created by Shady Ramadan on 25/05/2026.
//

import UIKit

class LeaguesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let leagues: [(name: String, country: String)] = [
        ("Premier League", "England"),
        ("La Liga", "Spain"),
        ("Serie A", "Italy"),
        ("Bundesliga", "Germany"),
        ("Ligue 1", "France"),
        ("Egyptian League", "Egypt")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("entered")

        title = "Leagues"

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension LeaguesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        return leagues.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "LeagueCell",
            for: indexPath
        ) as? LeagueCell else {

            return UITableViewCell()
        }
        cell.startFlashying()

        let league = leagues[indexPath.row]

        cell.leagueNameLabel.text = league.name
        cell.countryLabel.text = league.country

        return cell
    }
}
