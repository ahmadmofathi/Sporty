//
//  OnboardingPager.swift
//  sporty
//
//  Created by Ahmad on 06/06/2026.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {

    private let pageControl = UIPageControl()
    private var pages: [OnboardingPage] = [

        OnboardingPage(
            title: "All Your Sports. One Place.",
            description: "Follow football, basketball, tennis and cricket from a single powerful platform.",
            imageName: "onboarding1"
        ),

        OnboardingPage(
            title: "Live Scores & Fixtures",
            description: "Track upcoming matches, live scores and completed fixtures in real time.",
            imageName: "onboarding2"
        ),

        OnboardingPage(
            title: "Teams & Player Statistics",
            description: "Explore teams, players and detailed match statistics across leagues.",
            imageName: "onboarding3"
        )
    ]

    private var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        let appearance = UIPageControl.appearance()

        appearance.currentPageIndicatorTintColor = .systemBlue
        appearance.pageIndicatorTintColor = .lightGray
        
        createPages()

        if let first = controllers.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true
            )
        }
        
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func createPages() {

        let storyboard = UIStoryboard(
            name: "onboarding",
            bundle: nil
        )

        controllers = pages.map {

            let vc = storyboard.instantiateViewController(
                withIdentifier: "OnboardingContentVC"
            ) as! OnboardingContentViewController

            vc.page = $0

            return vc
        }
    }
}
extension OnboardingPageViewController:
UIPageViewControllerDataSource,
UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard let index =
                controllers.firstIndex(of: viewController),
              index > 0 else {
            return nil
        }

        return controllers[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard let index = controllers.firstIndex(of: viewController)
        else {
            return nil
        }

        if index == controllers.count - 1 {

            UserDefaults.standard.set(
                true,
                forKey: "didFinishOnboarding"
            )

            let storyboard = UIStoryboard(
                name: "Main",
                bundle: nil
            )

            let homeVC = storyboard.instantiateInitialViewController()!

            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {

                    window.rootViewController = homeVC
                    window.makeKeyAndVisible()
                }
            }

            return nil
        }

        return controllers[index + 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {

        guard completed,
              let current =
                viewControllers?.first,
              let index =
                controllers.firstIndex(of: current)
        else { return }

        pageControl.currentPage = index
    }
}
