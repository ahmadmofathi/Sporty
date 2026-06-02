import UIKit

protocol MainLeagueViewProtocol: AnyObject {
    func displayData(
        upcoming: [Fixture],
        latest: [Fixture],
        teams: [LeagueTeam]
    )
    func navigateToTeamDetails(with teamId: Int)
}

class MainLeagueViewController: UIViewController, MainLeagueViewProtocol {

    @IBOutlet weak var upComingCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!

    var leagueId: Int = 34
    private var presenter: MainLeaguePresenter!

    private var upcomingEvents: [Fixture] = []
    private var latestEvents: [Fixture] = []
    private var teams: [LeagueTeam] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        upComingCollectionView.delegate = self
        upComingCollectionView.dataSource = self

        teamsCollectionView.delegate = self
        teamsCollectionView.dataSource = self

        latestCollectionView.delegate = self
        latestCollectionView.dataSource = self

        presenter = MainLeaguePresenter(
            view: self,
            leagueId: leagueId
        )

        presenter.viewDidLoad()
    }

    func displayData(
        upcoming: [Fixture],
        latest: [Fixture],
        teams: [LeagueTeam]
    ) {
        self.upcomingEvents = upcoming
        self.latestEvents = latest
        self.teams = teams

        upComingCollectionView.reloadData()
        latestCollectionView.reloadData()
        teamsCollectionView.reloadData()
    }

    func navigateToTeamDetails(with teamId: Int) {
        let storyboard = UIStoryboard(
            name: "SquadScreen",
            bundle: nil
        )

        guard let squadVC = storyboard.instantiateViewController(
            withIdentifier: "SquadVC"
        ) as? SquadViewController else {
            return
        }

        squadVC.teamId = teamId

        navigationController?.pushViewController(
            squadVC,
            animated: true
        )
    }
}

extension MainLeagueViewController: UICollectionViewDataSource {

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

        // UPCOMING EVENTS
        if collectionView == upComingCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "UpComingEventCell",
                for: indexPath
            ) as! UpComingEventCellCollectionViewCell

            let event = upcomingEvents[indexPath.row]
            cell.team1Name.text = event.eventHomeTeam
            cell.team2Name.text = event.eventAwayTeam
            cell.eventDate.text = event.eventDate
            cell.matchWeek.text = event.leagueRound

            cell.team1Img.loadImage(from: event.homeTeamLogo)
            cell.team2Img.loadImage(from: event.awayTeamLogo)

            return cell
        }

        // LATEST MATCHES (تم تصحيح الـ Identifier هنا ليتطابق مع الـ Storyboard)
        if collectionView == latestCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "latestCell",
                for: indexPath
            ) as! LatestCollectionViewCell

            let match = latestEvents[indexPath.row]
            cell.teamATitle.text = match.eventHomeTeam
            cell.teamBTitle.text = match.eventAwayTeam
            cell.result.text = match.eventFinalResult

            cell.teamAImage.loadImage(from: match.homeTeamLogo)
            cell.teamBImage.loadImage(from: match.awayTeamLogo)

            return cell
        }

        // TEAMS
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TeamCell",
            for: indexPath
        ) as! TeamCollectionViewCell

        let team = teams[indexPath.row]
        cell.teamTitle.text = team.teamName
        cell.teamLogo.loadImage(from: team.teamLogo)

        return cell
    }
}

extension MainLeagueViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let availableWidth = collectionView.frame.width

        if collectionView == upComingCollectionView {
            // يعطي براح جانبي ممتاز للكروت الأفقية العريضة
            return CGSize(width: availableWidth - 16, height: 200)
        }

        if collectionView == latestCollectionView {
            // كروت الـ Latest Matches هتاخد الـ Width كامل للشاشة ناقص الهوامش البسيطة
            return CGSize(width: availableWidth, height: 140)
        }

        // كروت الـ Teams الدائرية
        return CGSize(width: 100, height: 120)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if collectionView == teamsCollectionView {
            presenter.didSelectTeam(at: indexPath.row)
        }
    }
}

extension UIImageView {
    func loadImage(from urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
