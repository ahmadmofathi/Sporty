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
            ("firstpage", L10n.Onboarding.title1, L10n.Onboarding.desc1),
            ("secondpage", L10n.Onboarding.title2, L10n.Onboarding.desc2),
            ("3rdpage", L10n.Onboarding.title3, L10n.Onboarding.desc3)
        ]

        for item in data {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "page1") as? OnboardingPageViewController else { continue }
            vc.configure(imageName: item.0, title: item.1, description: item.2)
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
        guard let pageVC = viewController as? OnboardingPageViewController, let index = pages.firstIndex(of: pageVC), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? OnboardingPageViewController, let index = pages.firstIndex(of: pageVC), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first as? OnboardingPageViewController, let index = pages.firstIndex(of: visibleVC) {
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
