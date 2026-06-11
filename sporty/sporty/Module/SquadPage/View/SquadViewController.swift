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

    private var emptyStateView: EmptyStateView!

    override func viewDidLoad() {
        super.viewDidLoad()

        emptyStateView = addEmptyStateView()

        squadTable.delegate = self
        squadTable.dataSource = self

        teamName.text = teamNameText ?? L10n.General.na
        leagueName.text = leagueNameText ?? L10n.General.na
        staduimName.text = stadiumNameText ?? L10n.General.na

        presenter = SquadPresenter(
            view: self,
            sport: self.sportType ?? "football"
        )

        presenter.getPlayers(
            teamId: self.teamId
        )
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

        emptyStateView.configure(preset: .noInternet, subtitle: L10n.Network.noInternetBody)
        emptyStateView.showAnimated()
        squadTable.isHidden = true
    }

    func showEmptyState(message: String) {

        emptyStateView.configure(preset: .noPlayers, subtitle: message)
        emptyStateView.showAnimated()
        squadTable.isHidden = true
    }

    func hideEmptyState() {

        emptyStateView.hideAnimated()
        squadTable.isHidden = false
    }

    func showLoading() {
        showSkeletonOverlay(style: .rows(count: 5), over: view)
    }

    func hideLoading() {
        hideSkeletonOverlay()
    }

    func showError(message: String) {

        let alert = UIAlertController(
            title: L10n.General.error,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: L10n.General.ok,
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
        player.playerName ?? L10n.General.unknown

        cell.playerNumber.text =
        player.playerNumber ?? L10n.General.dash

        cell.playerInfo.text =
        L10n.Player.info(type: player.playerType ?? "", age: player.playerAge ?? L10n.General.dash)

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
