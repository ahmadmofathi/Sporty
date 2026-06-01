import UIKit

class HomeViewController: UIViewController, SportsViewProtocol, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var presenter: HomePresenter!
    private var sportsNames: [String] = []
    private var sportsImages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("entered")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        
        let padding: CGFloat = 16
        let minimumSpacing: CGFloat = 10
        let totalWidthPadding = (padding * 2) + minimumSpacing
        
        let cellWidth = (collectionView.bounds.width - totalWidthPadding) / 2
        let cellHeight: CGFloat
        if collectionView.bounds.width > collectionView.bounds.height {
            cellHeight = 250
        } else {
            cellHeight = (collectionView.bounds.height - 8) / 2
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportCell", for: indexPath)
        
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            imageView.image = UIImage(named: sportsImages[indexPath.row])
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
        }
        
        if let label = cell.viewWithTag(200) as? UILabel {
            label.text = sportsNames[indexPath.row]
        }
        
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.05
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.clipsToBounds = false
        cell.backgroundColor = .systemBackground
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectSport(at: indexPath.row)
    }
    func navigateToLeague(with sportName: String) {
        let lvc = UIStoryboard(name: "league" , bundle: nil)
        if let leagueVC = lvc.instantiateViewController(withIdentifier: "LeagueVC") as? LeaguesViewController {
            
            
            self.navigationController?.pushViewController(leagueVC, animated: true)    }
    }
}
