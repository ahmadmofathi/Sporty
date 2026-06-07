import UIKit

class OnboardingPageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func configure(imageName: String, title: String, description: String) {
        loadViewIfNeeded()
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
