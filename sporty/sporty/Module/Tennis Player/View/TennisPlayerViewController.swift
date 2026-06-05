import UIKit

protocol TennisPlayerViewProtocol: AnyObject {
    func displayPlayerProfile(_ profile: TennisPlayerProfile)
    func reloadStatsTable()
    func showError(message: String)
    func showLoading()
    func hideLoading()
}

class TennisPlayerViewController: UIViewController {

    @IBOutlet var hiddenBtn: UIButton!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var PlayerNation: UILabel!
    @IBOutlet weak var bithDate: UILabel!
    @IBOutlet weak var rankNumber: UILabel!
    @IBOutlet weak var proSince: UILabel!
    @IBOutlet weak var totalGrandSlams: UILabel!
    @IBOutlet weak var playerSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!

    var playerKey: Int = 0
    var leagueId: Int = 0
    private var presenter: TennisPlayerPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenBtn.isHidden = true
        presenter = TennisPlayerPresenter(view: self)
        presenter.leagueId = leagueId
        setupTableView()
        presenter.fetchPlayerDetails(playerKey: playerKey)
        playerSegmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.isScrollEnabled = false
    }

    @objc private func segmentChanged() {
        tableView.reloadData()
        updateTableHeight()
    }

    private func updateTableHeight() {
        let rowCount = presenter.getNumberOfRows(for: playerSegmentControl.selectedSegmentIndex)
        tableViewHeight.constant = CGFloat(rowCount) * 90
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension TennisPlayerViewController: TennisPlayerViewProtocol {

    func showLoading() {}

    func hideLoading() {}

    func reloadStatsTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateTableHeight()
        }
    }

    func displayPlayerProfile(_ profile: TennisPlayerProfile) {
        DispatchQueue.main.async {
            self.playerName.text = profile.name
            self.PlayerNation.text = profile.nation
            self.bithDate.text = profile.birthDate ?? "-"
            self.rankNumber.text = self.presenter.getBestRank()
            self.proSince.text = self.presenter.getProSince()
            self.totalGrandSlams.text = self.presenter.getTotalTitles()
            if let urlString = profile.imageURL, let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async { self.playerImage.image = image }
                }.resume()
            }
            self.tableView.reloadData()
            self.updateTableHeight()
        }
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TennisPlayerViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRows(for: playerSegmentControl.selectedSegmentIndex)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath) as? TennisPlayerCustomCell else {
            return UITableViewCell()
        }
        if playerSegmentControl.selectedSegmentIndex == 0 {
            if let stat = presenter.getStat(at: indexPath.row) {
                cell.configureStat(with: stat)
            }
        } else {
            if let tournament = presenter.getTournament(at: indexPath.row) {
                cell.configureTournament(with: tournament)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
