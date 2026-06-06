import UIKit
import SDWebImage
import Foundation

protocol MainLeagueViewProtocol: AnyObject {
    func setLeagueName(_ name: String)
    func showNoInternet()
    func showEmptyState(message: String)
    func hideEmptyState()

    func displayData(
        upcoming: [MatchProtocol],
        latest: [MatchProtocol],
        teams: [LeagueTeam]
    )

    func navigateToTeamDetails(with teamId: Int)
    func navigateToTennisDetails(with playerKey: Int)
}

class MainLeagueViewController: UIViewController,
                                MainLeagueViewProtocol,
                                UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var upComingCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionHeight: NSLayoutConstraint!

    var leagueId: Int = 34
    var leagueName: String = "Unknown League"
    var sportType: String = "football"

    private var presenter: MainLeaguePresenter!

    private var upcomingEvents: [MatchProtocol] = []
    private var latestEvents: [MatchProtocol] = []
    private var teams: [LeagueTeam] = []

    private let emptyStateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDelegates()
        setupEmptyState()

        presenter = MainLeaguePresenter(
            view: self,
            leagueId: leagueId,
            sport: sportType
        )

        presenter.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        upComingCollectionView.collectionViewLayout.invalidateLayout()
        latestCollectionView.collectionViewLayout.invalidateLayout()
        teamsCollectionView.collectionViewLayout.invalidateLayout()
    }

    private func setupDelegates() {
        upComingCollectionView.delegate = self
        upComingCollectionView.dataSource = self

        latestCollectionView.delegate = self
        latestCollectionView.dataSource = self

        teamsCollectionView.delegate = self
        teamsCollectionView.dataSource = self
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

    // MARK: - View Protocol

    func setLeagueName(_ name: String) {
        leagueName = name
        title = name
    }

    func displayData(
        upcoming: [MatchProtocol],
        latest: [MatchProtocol],
        teams: [LeagueTeam]
    ) {
        self.upcomingEvents = upcoming
        self.latestEvents = latest
        self.teams = teams

        DispatchQueue.main.async {
            self.hideEmptyState()

            self.upComingCollectionView.reloadData()
            self.latestCollectionView.reloadData()
            self.teamsCollectionView.reloadData()

            self.updateLatestCollectionHeight()
        }
    }

    func showNoInternet() {
        emptyStateLabel.text =
        """
        📡 No Internet Connection

        Please check your internet connection and try again.
        """

        emptyStateLabel.isHidden = false

        upComingCollectionView.isHidden = true
        latestCollectionView.isHidden = true
        teamsCollectionView.isHidden = true
    }

    func showEmptyState(message: String) {
        emptyStateLabel.text = message

        emptyStateLabel.isHidden = false

        upComingCollectionView.isHidden = true
        latestCollectionView.isHidden = true
        teamsCollectionView.isHidden = true
    }

    func hideEmptyState() {
        emptyStateLabel.isHidden = true

        upComingCollectionView.isHidden = false
        latestCollectionView.isHidden = false
        teamsCollectionView.isHidden = false
    }

    // MARK: - Navigation

    func navigateToTeamDetails(with teamId: Int) {
        let storyboard = UIStoryboard(
            name: "SquadScreen",
            bundle: nil
        )

        if let vc = storyboard.instantiateViewController(
            withIdentifier: "SquadVC"
        ) as? SquadViewController {

            vc.teamId = teamId

            navigationController?.pushViewController(
                vc,
                animated: true
            )
        }
    }

    func navigateToTennisDetails(with playerKey: Int) {
        let storyboard = UIStoryboard(
            name: "TennisPlayerProfile",
            bundle: nil
        )

        if let vc = storyboard.instantiateViewController(
            withIdentifier: "TennisVC"
        ) as? TennisPlayerViewController {

            vc.playerKey = playerKey
            vc.leagueId = leagueId

            navigationController?.pushViewController(
                vc,
                animated: true
            )
        }
    }

    // MARK: - Layout

    private func updateLatestCollectionHeight() {
        let itemHeight: CGFloat = 190
        let spacing: CGFloat = 14
        let count = CGFloat(latestEvents.count)

        latestCollectionHeight.constant =
            count > 0
            ? (count * itemHeight) + ((count - 1) * spacing)
            : 0

        view.layoutIfNeeded()
    }

    // MARK: - Collection View

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {

        if collectionView == upComingCollectionView {
            return upcomingEvents.count
        }

        if collectionView == latestCollectionView {
            return latestEvents.count
        }

        return teams.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if collectionView == upComingCollectionView {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "UpComingEventCell",
                for: indexPath
            ) as! UpComingEventCellCollectionViewCell

            let match = upcomingEvents[indexPath.row]

            cell.team1Name.text = match.title1 ?? "-"
            cell.team2Name.text = match.title2 ?? "-"

            cell.team1Img.sd_setImage(
                with: URL(string: match.logo1 ?? ""),
                placeholderImage: UIImage(named: "team")
            )

            cell.team2Img.sd_setImage(
                with: URL(string: match.logo2 ?? ""),
                placeholderImage: UIImage(named: "team")
            )

            return cell
        }

        if collectionView == latestCollectionView {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "latestCell",
                for: indexPath
            ) as! LatestCollectionViewCell

            let match = latestEvents[indexPath.row]

            cell.teamATitle.text = match.title1 ?? "-"
            cell.teamBTitle.text = match.title2 ?? "-"
            cell.result.text = match.result ?? "-"

            cell.teamAImage.sd_setImage(
                with: URL(string: match.logo1 ?? ""),
                placeholderImage: UIImage(named: "team")
            )

            cell.teamBImage.sd_setImage(
                with: URL(string: match.logo2 ?? ""),
                placeholderImage: UIImage(named: "team")
            )

            return cell
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TeamCell",
            for: indexPath
        ) as! TeamCollectionViewCell

        let team = teams[indexPath.row]

        cell.teamTitle.text = team.teamName ?? "-"

        cell.teamLogo.sd_setImage(
            with: URL(string: team.teamLogo ?? ""),
            placeholderImage: UIImage(named: "team")
        )

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if collectionView == upComingCollectionView {
            return CGSize(width: 320, height: 212)
        }

        if collectionView == latestCollectionView {
            return CGSize(
                width: collectionView.bounds.width,
                height: 190
            )
        }

        return CGSize(width: 80, height: 116)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {

        return collectionView == latestCollectionView ? 14 : 16
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {

        return collectionView == latestCollectionView
        ? UIEdgeInsets.zero
        : UIEdgeInsets(
            top: 8,
            left: 16,
            bottom: 8,
            right: 16
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {

        return 8
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        guard collectionView == teamsCollectionView else { return }

        let teamId = teams[indexPath.row].teamKey ?? 0

        if sportType.lowercased() == "tennis" {
            navigateToTennisDetails(with: teamId)
        } else {
            navigateToTeamDetails(with: teamId)
        }
    }
}
