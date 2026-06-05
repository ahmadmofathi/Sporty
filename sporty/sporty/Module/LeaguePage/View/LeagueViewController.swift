import UIKit
import SDWebImage

class LeaguesViewController: UIViewController, LeaguesViewProtocol {

    @IBOutlet weak var mySearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private var presenter: LeaguePresenter!

    private var leagueNames: [String] = []
    private var leagueCountries: [String] = []
    private var leagueLogos: [String] = []
    private var leagueFavorites: [Bool] = []

    var selectedSport: String?

    private let emptyStateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Leagues"

        setupEmptyState()

        tableView.delegate = self
        tableView.dataSource = self

        mySearch.delegate = self

        let sportToFetch = selectedSport ?? "football"

        presenter = LeaguePresenter(
            view: self,
            sport: sportToFetch
        )

        presenter.viewDidLoad()
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

    func displayLeagues(
        _ names: [String],
        countries: [String],
        logos: [String],
        favorites: [Bool]
    ) {

        self.leagueNames = names
        self.leagueCountries = countries
        self.leagueLogos = logos
        self.leagueFavorites = favorites

        DispatchQueue.main.async {

            self.hideEmptyState()

            self.tableView.reloadData()
        }
    }

    func navigateToLeague(with leagueId: Int) {

        let ml = UIStoryboard(
            name: "MainLeague",
            bundle: nil
        )

        if let mainLeagueVC = ml.instantiateViewController(
            withIdentifier: "MainLeagueVC"
        ) as? MainLeagueViewController {

            mainLeagueVC.leagueId = leagueId
            mainLeagueVC.sportType = self.selectedSport ?? "football"

            navigationController?.pushViewController(
                mainLeagueVC,
                animated: true
            )
        }
    }

    func showNoInternet() {

        emptyStateLabel.text =
        """
        📡 No Internet Connection

        Please check your internet connection and try again.
        """

        emptyStateLabel.isHidden = false

        tableView.isHidden = true
        mySearch.isHidden = true
    }

    func showEmptyState(message: String) {

        emptyStateLabel.text = message

        emptyStateLabel.isHidden = false

        tableView.isHidden = true
    }

    func hideEmptyState() {

        emptyStateLabel.isHidden = true

        tableView.isHidden = false
        mySearch.isHidden = false
    }
}

extension LeaguesViewController:
UITableViewDelegate,
UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        leagueNames.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "LeagueCell",
            for: indexPath
        ) as? LeagueCell else {

            return UITableViewCell()
        }

        cell.leagueNameLabel.text =
        leagueNames[indexPath.row]

        cell.countryLabel.text =
        leagueCountries[indexPath.row]

        let isFav =
        leagueFavorites[indexPath.row]

        let heartImage =
        isFav
        ? UIImage(systemName: "heart.fill")
        : UIImage(systemName: "heart")

        cell.favoriteButton.setImage(
            heartImage,
            for: .normal
        )

        cell.onFavoriteTapped = { [weak self] in

            self?.presenter.toggleFavorite(
                at: indexPath.row
            )
        }

        let defaultPlaceholder =
        UIImage(named: "league_placeholder")

        let logoURLString =
        leagueLogos[indexPath.row]

        if let url = URL(string: logoURLString),
           !logoURLString.isEmpty {

            cell.logoImageView.sd_setImage(
                with: url,
                placeholderImage: defaultPlaceholder,
                options: [
                    .retryFailed,
                    .continueInBackground
                ]
            )

        } else {

            cell.logoImageView.image =
            defaultPlaceholder
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {

        if let leagueCell = cell as? LeagueCell {

            leagueCell.startFlashying()
        }
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        presenter.didSelectLeague(
            at: indexPath.row
        )
    }
}

extension LeaguesViewController:
UISearchBarDelegate {

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {

        presenter.filterLeagues(
            with: searchText
        )
    }

    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar
    ) {

        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(
        _ searchBar: UISearchBar
    ) {

        searchBar.text = ""

        searchBar.resignFirstResponder()

        presenter.filterLeagues(
            with: ""
        )
    }
}
