import UIKit
import SDWebImage

class SquadViewController: UIViewController {

    @IBOutlet weak var squadTable: UITableView!
    @IBOutlet weak var staduimName: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var leagueName: UILabel!

    var presenter: SquadPresenterProtocol!
    var teamId: Int = 96
    
    var teamNameText: String?
    var leagueNameText: String?
    var stadiumNameText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        squadTable.delegate = self
        squadTable.dataSource = self

        teamName.text = teamNameText ?? "N/A"
        leagueName.text = leagueNameText ?? "N/A"
        staduimName.text = stadiumNameText ?? "N/A"

        presenter = SquadPresenter(view: self)
        presenter.getPlayers(teamId: teamId)
    }
}

extension SquadViewController: SquadViewProtocol {

    func renderPlayers() {
        DispatchQueue.main.async {
            self.squadTable.reloadData()
        }
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SquadViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerTableViewCell else {
            return UITableViewCell()
        }

        let player = presenter.players[indexPath.row]

        cell.playerName.text = player.playerName ?? "Unknown"
        cell.playerNumber.text = player.playerNumber ?? "-"
        cell.playerInfo.text = "\(player.playerType ?? "") • Age: \(player.playerAge ?? "-")"

        if let imageUrlString = player.playerImage, let url = URL(string: imageUrlString) {
            cell.playerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "monkey_placeholder"))
        } else {
            cell.playerImage.image = UIImage(named: "monkey_placeholder")
        }

        return cell
    }
}
