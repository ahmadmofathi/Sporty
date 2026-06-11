import UIKit

class HomeViewController: UIViewController, SportsViewProtocol, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var presenter: HomePresenter!
    private var sportsNames: [String] = []
    private var sportsImages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = ThemeManager.backgroundPrimary
        view.backgroundColor = ThemeManager.backgroundPrimary
        
        presenter = HomePresenter(view: self)
        presenter.viewDidLoad()
    }
    
    func displaySports(_ names: [String], images: [String]) {
        self.sportsNames = names
        self.sportsImages = images
        self.collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding = DS.Layout.sportsGridPadding
        let minimumSpacing = DS.Layout.sportsGridSpacing
        let totalWidthPadding = (padding * 2) + minimumSpacing
        
        let cellWidth = (collectionView.bounds.width - totalWidthPadding) / 2
        let cellHeight: CGFloat
        if collectionView.bounds.width > collectionView.bounds.height {
            cellHeight = DS.CellSize.sportsCardLandscapeHeight
        } else {
            cellHeight = (collectionView.bounds.height - DS.Layout.sportsGridLineSpacing) / 2
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DS.Layout.sportsGridLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportCell", for: indexPath) as? SportsCell else {
            return UICollectionViewCell()
        }
        
        cell.sportImageView.image = UIImage(named: sportsImages[indexPath.row])
        cell.sportImageView.contentMode = .scaleAspectFill
        cell.sportImageView.layer.cornerRadius = DS.CornerRadius.medium
        cell.sportImageView.clipsToBounds = true
        
        cell.sportLabel.text = sportsNames[indexPath.row]
        cell.sportLabel.textColor = ThemeManager.textPrimary
        
        cell.applyCardStyle(cornerRadius: DS.CornerRadius.medium, shadow: DS.Shadow.subtle)
        cell.backgroundColor = ThemeManager.backgroundCard
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectSport(at: indexPath.row)
    }
    
    func navigateToLeague(with sportName: String) {
        let lvc = UIStoryboard(name: "league" , bundle: nil)
        if let leagueVC = lvc.instantiateViewController(withIdentifier: "LeagueVC") as? LeaguesViewController {
            leagueVC.selectedSport = sportName
            self.navigationController?.pushViewController(leagueVC, animated: true)
        }
    }
}
