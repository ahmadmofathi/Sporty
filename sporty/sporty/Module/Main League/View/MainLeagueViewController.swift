import UIKit
import SDWebImage

protocol MainLeagueViewProtocol: AnyObject {
    func displayData(upcoming: [Fixture], latest: [Fixture], teams: [LeagueTeam])
    func navigateToTeamDetails(with teamId: Int)
    func setLeagueName(_ name: String)
}

class MainLeagueViewController: UIViewController, MainLeagueViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var upComingCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionHeight: NSLayoutConstraint!

    var leagueId: Int = 34
    var leagueName: String = "Unknown League"
    var sportType: String = "football"
    private var presenter: MainLeaguePresenter!
    
    private var upcomingEvents: [Fixture] = []
    private var latestEvents: [Fixture] = []
    private var teams: [LeagueTeam] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
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

    func displayData(upcoming: [Fixture], latest: [Fixture], teams: [LeagueTeam]) {
        self.upcomingEvents = upcoming
        self.latestEvents = latest
        self.teams = teams
        
        DispatchQueue.main.async {
            self.upComingCollectionView.reloadData()
            self.latestCollectionView.reloadData()
            self.teamsCollectionView.reloadData()
            self.updateLatestCollectionHeight()
        }
    }

    func navigateToTeamDetails(with teamId: Int) {
        let sq = UIStoryboard(name: "SquadScreen", bundle: nil)
        if let squadVC = sq.instantiateViewController(withIdentifier: "SquadVC") as? SquadViewController {
            squadVC.teamId = teamId
            navigationController?.pushViewController(squadVC, animated: true)
        }
    }

    func setLeagueName(_ name: String) {
        self.leagueName = name
    }
    
    private func updateLatestCollectionHeight() {
        let rows = CGFloat(latestEvents.count)
        let itemHeight: CGFloat = 190
        let spacing: CGFloat = 14
        let topBottomInsets: CGFloat = 0
        
        if rows > 0 {
            latestCollectionHeight?.constant = (rows * itemHeight) + ((rows - 1) * spacing) + topBottomInsets
        } else {
            latestCollectionHeight?.constant = 0
        }
        view.layoutIfNeeded()
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
            cell.team1Name.text = match.eventHomeTeam
            cell.team2Name.text = match.eventAwayTeam
            cell.eventDate.text = match.eventDate
            cell.team1Img.sd_setImage(with: URL(string: match.homeTeamLogo ?? ""))
            cell.team2Img.sd_setImage(with: URL(string: match.awayTeamLogo ?? ""))
            return cell
        }
        
        if collectionView == latestCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestCell", for: indexPath) as! LatestCollectionViewCell
            let match = latestEvents[indexPath.row]
            cell.teamATitle.text = match.eventHomeTeam
            cell.teamBTitle.text = match.eventAwayTeam
            cell.result.text = match.eventFinalResult
            cell.teamAImage.sd_setImage(with: URL(string: match.homeTeamLogo ?? ""))
            cell.teamBImage.sd_setImage(with: URL(string: match.awayTeamLogo ?? ""))
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCollectionViewCell
        let team = teams[indexPath.row]
        cell.teamTitle.text = team.teamName
        cell.teamLogo.sd_setImage(with: URL(string: team.teamLogo ?? ""))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == upComingCollectionView {
            return CGSize(width: 320, height: 212)
        }
        if collectionView == latestCollectionView {
            return CGSize(width: collectionView.bounds.width, height: 190)
        }
        return CGSize(width: 80, height: 116)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == latestCollectionView {
            return 14
        }
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == latestCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == teamsCollectionView { presenter.didSelectTeam(at: indexPath.row) }
    }
}
