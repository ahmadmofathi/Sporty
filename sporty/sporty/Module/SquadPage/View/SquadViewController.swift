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
    var sportType: String?

    private let emptyStateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupEmptyState()

        squadTable.delegate = self
        squadTable.dataSource = self

        teamName.text = teamNameText ?? "N/A"
        leagueName.text = leagueNameText ?? "N/A"
        staduimName.text = stadiumNameText ?? "N/A"

        presenter = SquadPresenter(
            view: self,
            sport: self.sportType ?? "football"
        )

        presenter.getPlayers(
            teamId: self.teamId
        )
    }

    private func setupEmptyState() {

        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.font = .systemFont(ofSize: 18)
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.isHidden = true

        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension SquadViewController: SquadViewProtocol {

    func renderPlayers() {

        hideEmptyState()

        DispatchQueue.main.async {
            self.squadTable.reloadData()
        }
    }

    func showNoInternet() {

        emptyStateLabel.text =
        """
        📡 No Internet Connection

        Please check your internet connection and try again.
        """

        emptyStateLabel.isHidden = false
        squadTable.isHidden = true
    }

    func showEmptyState(message: String) {

        emptyStateLabel.text = message
        emptyStateLabel.isHidden = false

        squadTable.isHidden = true
    }

    func hideEmptyState() {

        emptyStateLabel.isHidden = true
        squadTable.isHidden = false
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

        present(
            alert,
            animated: true
        )
    }
}

extension SquadViewController:
UITableViewDelegate,
UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return presenter.players.count
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
        "\(player.playerType ?? "") • Age: \(player.playerAge ?? "-")"

        let placeholder: UIImage?
        print("Type:")
        print(self.sportType as Any)
        switch self.sportType?.lowercased() {

        case "football":
            placeholder = UIImage(named: "footballPlayer")

        case "basketball":
            placeholder = UIImage(named: "basketballPlayer")

        case "cricket":
            placeholder = UIImage(named: "cricketPlayer")

        default:
            placeholder = UIImage(named: "defaultPlayer")
        }


        if let imageUrl = player.playerImage,
           let url = URL(string: imageUrl) {

            cell.playerImage.sd_setImage(
                with: url,
                placeholderImage: placeholder
            )

        } else {

            cell.playerImage.image = placeholder
        }

        return cell
    }
}
