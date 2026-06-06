import UIKit

class OnboardingContentViewController: UIViewController {

    @IBOutlet var finishButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var page: OnboardingPage?
    var isLastPage: Bool = false
    var onFinish: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = page?.title
        descriptionLabel.text = page?.description
        imageView.image = UIImage(named: page?.imageName ?? "")
        finishButton.isHidden = !isLastPage
        
    }

    @IBAction func finishTapped(_ sender: UIButton) {
        onFinish?()
    }
}
