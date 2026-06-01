import UIKit
import SDWebImage
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

extension SquadViewController: UITableViewDelegate, UITableViewDataSource {

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

        cell.playerName.text = player.playerName ?? "Unknown"
        cell.playerNumber.text = player.playerNumber ?? "-"
        
        // شيلنا الـ playerCountry لأن الـ API مش بيرجعه في الـ Teams عشان السطر يطلع مظبوط
        cell.playerInfo.text = "\(player.playerType ?? "") • Age: \(player.playerAge ?? "-")"

        // ⬇️ 🔥 استخدام SDWebImage السحري لشحن الصورة 🔥 ⬇️
        // تأكدوا إن اسم الـ Outlet جوه الـ PlayerTableViewCell هو playerImageView
        if let imageUrlString = player.playerImage, let url = URL(string: imageUrlString) {
            cell.playerImage.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "monkey_placeholder")      )
        } else {
                   cell.playerImage.image = UIImage(named: "monkey_placeholder")
        }

        return cell
    }
}
