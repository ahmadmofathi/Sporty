import UIKit
import SDWebImage
import Foundation

protocol MainLeagueViewProtocol: AnyObject {
    func setLeagueName(_ name: String)
    func showNoInternet()
    func showEmptyState(message: String)
    func hideEmptyState()
    func displayData(upcoming: [MatchProtocol], latest: [MatchProtocol], teams: [LeagueTeam])
    func navigateToTeamDetails(with teamId: Int, teamName: String)
    func navigateToTennisDetails(with playerKey: Int)
}

class MainLeagueViewController: UIViewController, MainLeagueViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var upComingCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionHeight: NSLayoutConstraint!

    var leagueId: Int = 34
    var leagueName: String = L10n.General.unknownLeague
    var sportType: String = "football"

    private var presenter: MainLeaguePresenter!
    private var upcomingEvents: [MatchProtocol] = []
    private var latestEvents: [MatchProtocol] = []
    private var teams: [LeagueTeam] = []
    private var emptyStateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.backgroundPrimary
        upComingCollectionView.backgroundColor = ThemeManager.backgroundPrimary
        teamsCollectionView.backgroundColor = ThemeManager.backgroundPrimary
        latestCollectionView.backgroundColor = ThemeManager.backgroundPrimary
        
        setupDelegates()
        emptyStateLabel = addEmptyStateLabel()
        presenter = MainLeaguePresenter(view: self, leagueId: leagueId, sport: sportType)
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



    func setLeagueName(_ name: String) {
        leagueName = name
        title = name
    }

    func displayData(upcoming: [MatchProtocol], latest: [MatchProtocol], teams: [LeagueTeam]) {
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
        emptyStateLabel.text = L10n.Network.noInternetFull
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

    func navigateToTeamDetails(with teamId: Int, teamName: String) {
        let storyboard = UIStoryboard(name: "SquadScreen", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SquadVC") as? SquadViewController {
            vc.teamId = teamId
            vc.sportType = self.sportType
            vc.teamNameText = teamName
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func navigateToTennisDetails(with playerKey: Int) {
        let storyboard = UIStoryboard(name: "TennisPlayerProfile", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TennisVC") as? TennisPlayerViewController {
            vc.playerKey = playerKey
            vc.leagueId = leagueId
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func updateLatestCollectionHeight() {
        let itemHeight = DS.CellSize.latestEventHeight
        let spacing = DS.CellSize.latestEventSpacing
        let count = CGFloat(latestEvents.count)
        latestCollectionHeight.constant = count > 0 ? (count * itemHeight) + ((count - 1) * spacing) : 0
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upComingCollectionView { return upcomingEvents.count }
        if collectionView == latestCollectionView { return latestEvents.count }
        return teams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upComingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingEventCell", for: indexPath) as! UpComingEventCellCollectionViewCell
            let match = upcomingEvents[indexPath.row]
            cell.team1Name.text = match.title1 ?? L10n.General.dash
            cell.team2Name.text = match.title2 ?? L10n.General.dash
            cell.team1Img.sd_setImage(with: URL(string: match.logo1 ?? ""), placeholderImage: UIImage(named: "team"))
            cell.team2Img.sd_setImage(with: URL(string: match.logo2 ?? ""), placeholderImage: UIImage(named: "team"))
            return cell
        }

        if collectionView == latestCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestCell", for: indexPath) as! LatestCollectionViewCell
            let match = latestEvents[indexPath.row]
            cell.teamATitle.text = match.title1 ?? L10n.General.dash
            cell.teamBTitle.text = match.title2 ?? L10n.General.dash
            cell.result.text = match.result ?? L10n.General.dash
            cell.teamAImage.sd_setImage(with: URL(string: match.logo1 ?? ""), placeholderImage: UIImage(named: "team"))
            cell.teamBImage.sd_setImage(with: URL(string: match.logo2 ?? ""), placeholderImage: UIImage(named: "team"))
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCollectionViewCell
        let team = teams[indexPath.row]
        cell.teamTitle.text = team.teamName ?? L10n.General.dash
        cell.teamLogo.sd_setImage(with: URL(string: team.teamLogo ?? ""), placeholderImage: UIImage(named: "team"))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == upComingCollectionView { return CGSize(width: DS.CellSize.upcomingEventWidth, height: DS.CellSize.upcomingEventHeight) }
        if collectionView == latestCollectionView { return CGSize(width: collectionView.bounds.width, height: DS.CellSize.latestEventHeight) }
        return CGSize(width: DS.CellSize.teamCellWidth, height: DS.CellSize.teamCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == latestCollectionView ? DS.CellSize.latestEventSpacing : DS.Layout.defaultLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionView == latestCollectionView ? UIEdgeInsets.zero : DS.Layout.collectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return DS.Layout.defaultInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == teamsCollectionView else { return }
        let team = teams[indexPath.row]
        let teamId = team.teamKey ?? 0
        let teamName = team.teamName ?? L10n.General.unknown
        if sportType.lowercased() == "tennis" {
            navigateToTennisDetails(with: teamId)
        } else {
            navigateToTeamDetails(with: teamId, teamName: teamName)
        }
    }
}
