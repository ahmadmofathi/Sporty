//
//  SquadViewController.swift
//  sporty
//
//  Created by Shady Ramadan on 31/05/2026.
//

import UIKit

class SquadViewController: UIViewController {

    @IBOutlet weak var squadTable: UITableView!

    var presenter: SquadPresenterProtocol!

    var teamId: Int = 96

    override func viewDidLoad() {
        super.viewDidLoad()

        squadTable.delegate = self
        squadTable.dataSource = self

        presenter = SquadPresenter(view: self)

        presenter.getPlayers(teamId: teamId)
    }
}
extension SquadViewController: SquadViewProtocol {

    func renderPlayers() {
        squadTable.reloadData()
    }

    func showError(message: String) {

        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}

extension SquadViewController:
UITableViewDelegate,
UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        presenter.players.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PlayerCell",
            for: indexPath
        ) as? PlayerTableViewCell else {

            return UITableViewCell()
        }

        let player = presenter.players[indexPath.row]

        cell.playerName.text =
            player.playerName ?? "Unknown"

        cell.playerNumber.text =
            player.playerNumber ?? "-"

        cell.playerInfo.text =
        "\(player.playerType ?? "") • \(player.playerCountry ?? "") • \(player.playerAge ?? "")"

        return cell
    }
}
