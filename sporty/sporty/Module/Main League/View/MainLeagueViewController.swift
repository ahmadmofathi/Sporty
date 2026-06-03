import UIKit
import SDWebImage

protocol MainLeagueViewProtocol: AnyObject {
    func displayData(upcoming: [Fixture], latest: [Fixture], teams: [LeagueTeam])
    func navigateToTeamDetails(with teamId: Int)
    func setLeagueName(_ name: String)
}

class MainLeagueViewController: UIViewController, MainLeagueViewProtocol {

    @IBOutlet weak var upComingCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionHeight: NSLayoutConstraint!

    var leagueId: Int = 34
    var leagueName: String = "Unknown League"
    private var presenter: MainLeaguePresenter!
    
    private var upcomingEvents: [Fixture] = []
    private var latestEvents: [Fixture] = []
    private var teams: [LeagueTeam] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        presenter = MainLeaguePresenter(view: self, leagueId: leagueId)
        presenter.viewDidLoad()
    }

    private func setupDelegates() {
        upComingCollectionView.delegate = self
        upComingCollectionView.dataSource = self
        teamsCollectionView.delegate = self
        teamsCollectionView.dataSource = self
        latestCollectionView.delegate = self
        latestCollectionView.dataSource = self
        latestCollectionView.isScrollEnabled = false
    }

    func setLeagueName(_ name: String) {
        self.leagueName = name
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

    private func updateLatestCollectionHeight() {
        guard let layout = latestCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let count = CGFloat(latestEvents.count)
        let totalHeight = (count * layout.itemSize.height) + ((count - 1) * layout.minimumLineSpacing)
        latestCollectionHeight.constant = max(totalHeight, 140)
        view.layoutIfNeeded()
    }

    func navigateToTeamDetails(with teamId: Int) {
        let storyboard = UIStoryboard(name: "SquadScreen", bundle: nil)
        guard let squadVC = storyboard.instantiateViewController(withIdentifier: "SquadVC") as? SquadViewController else { return }
        
        if let selectedTeam = teams.first(where: { $0.teamKey == teamId }) {
            squadVC.teamId = teamId
            squadVC.teamNameText = selectedTeam.teamName
            squadVC.leagueNameText = self.leagueName
            //squadVC.stadiumNameText = selectedTeam.teamStadium ?? ""
        }
        navigationController?.pushViewController(squadVC, animated: true)
    }
}

extension MainLeagueViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upComingCollectionView { return upcomingEvents.count }
        if collectionView == latestCollectionView { return latestEvents.count }
        return teams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upComingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingEventCell", for: indexPath) as! UpComingEventCellCollectionViewCell
            let event = upcomingEvents[indexPath.row]
            cell.team1Name.text = event.eventHomeTeam
            cell.team2Name.text = event.eventAwayTeam
            cell.eventDate.text = event.eventDate
            cell.matchWeek.text = event.leagueRound
            cell.team1Img.sd_setImage(with: URL(string: event.homeTeamLogo ?? ""))
            cell.team2Img.sd_setImage(with: URL(string: event.awayTeamLogo ?? ""))
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
        if collectionView == upComingCollectionView { return CGSize(width: collectionView.frame.width - 16, height: 200) }
        if collectionView == latestCollectionView { return CGSize(width: collectionView.bounds.width - 4, height: 140) }
        return CGSize(width: 100, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == teamsCollectionView { presenter.didSelectTeam(at: indexPath.row) }
    }
}
