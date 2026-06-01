import UIKit

protocol MainLeagueViewProtocol: AnyObject {
    func displayData(upcoming: [(team1: String, team2: String, score: String, week: String)], teams: [String])
    func navigateToTeamDetails(with teamName: String)
}

class MainLeagueViewController: UIViewController, MainLeagueViewProtocol {
    @IBOutlet var teamsCollectionView: UICollectionView!
    @IBOutlet var upComingCollectionView: UICollectionView!
    
    private var presenter: MainLeaguePresenter!
    private var upcomingEvents: [(team1: String, team2: String, score: String, week: String)] = []
    private var teams: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        upComingCollectionView.delegate = self
        upComingCollectionView.dataSource = self

        teamsCollectionView.delegate = self
        teamsCollectionView.dataSource = self
        
        presenter = MainLeaguePresenter(view: self)
        presenter.viewDidLoad()
    }
    
    func displayData(upcoming: [(team1: String, team2: String, score: String, week: String)], teams: [String]) {
        self.upcomingEvents = upcoming
        self.teams = teams
        self.upComingCollectionView.reloadData()
        self.teamsCollectionView.reloadData()
    }
    
    func navigateToTeamDetails(with teamName: String) {
        let sq = UIStoryboard(name: "SquadScreen", bundle: nil)
        if let SquadVC = sq.instantiateViewController(withIdentifier: "SquadVC") as? SquadViewController{
            self.navigationController?.pushViewController(SquadVC, animated: true)
        }
    }
}

extension MainLeagueViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upComingCollectionView {
            return upcomingEvents.count
        }
        return teams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upComingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingEventCell", for: indexPath) as! UpComingEventCellCollectionViewCell
            let event = upcomingEvents[indexPath.row]
            cell.team1Name.text = event.team1
            cell.team2Name.text = event.team2
            cell.eventDate.text = event.score
            cell.matchWeek.text = event.week
            cell.team1Img.image = UIImage(systemName: "sportscourt")
            cell.team2Img.image = UIImage(systemName: "sportscourt")
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCollectionViewCell
        cell.teamTitle.text = teams[indexPath.row]
        cell.teamLogo.image = UIImage(systemName: "shield.fill")
        return cell
    }
}

extension MainLeagueViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == upComingCollectionView {
            return CGSize(width: collectionView.frame.width - 20, height: 180)
        }
        return CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == teamsCollectionView {
            presenter.didSelectTeam(at: indexPath.row)
        }
    }
}
