import UIKit

class OnboardingContainerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var pageViewController: UIPageViewController!
    private var pages: [OnboardingPageViewController] = []

    @IBOutlet var pagesArea: UIView!
    @IBOutlet weak var dotsControl: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        setupPageViewController()

        btnNext.isUserInteractionEnabled = true
        btnSkip.isUserInteractionEnabled = true
        dotsControl.isUserInteractionEnabled = true

        view.bringSubviewToFront(btnNext)
        view.bringSubviewToFront(btnSkip)
        view.bringSubviewToFront(dotsControl)
    }

    private func setupPages() {
        let data = [
            ("firstpage", "Live Match Center", "Stay on top of the game with real-time updates."),
            ("secondpage", "Deep Squad Insights", "Explore your favorite team's tactical lineups."),
            ("3rdpage", "Real-time Alerts", "Get notified the second a goal is scored.")
        ]

        for item in data {
            let vc = storyboard?.instantiateViewController(withIdentifier: "page1") as! OnboardingPageViewController
            vc.loadViewIfNeeded()
            vc.imageView.image = UIImage(named: item.0)
            vc.titleLabel.text = item.1
            vc.descriptionLabel.text = item.2
            pages.append(vc)
        }
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true)

        addChild(pageViewController)
        pageViewController.view.frame = pagesArea.bounds
        pagesArea.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        view.sendSubviewToBack(pagesArea)

        dotsControl.numberOfPages = pages.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingPageViewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingPageViewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleVC as! OnboardingPageViewController) {
            dotsControl.currentPage = index
        }
    }

    @IBAction func nextPressed(_ sender: UIButton) {
        let nextIndex = dotsControl.currentPage + 1
        if nextIndex < pages.count {
            pageViewController.setViewControllers([pages[nextIndex]], direction: .forward, animated: true, completion: nil)
            dotsControl.currentPage = nextIndex
        } else {
            finishOnboarding(sender)
        }
    }

    @IBAction func skipPressed(_ sender: UIButton) {
        finishOnboarding(sender)
    }

    @IBAction func finishOnboarding(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")

        if let window = view.window {
            window.rootViewController = tabBarVC
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
}
