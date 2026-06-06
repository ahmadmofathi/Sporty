//
//  OnboardingContentViewController.swift
//  sporty
//
//  Created by Ahmad on 06/06/2026.
//

import UIKit

import UIKit

class OnboardingContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var page: OnboardingPage?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = page?.title
        descriptionLabel.text = page?.description
        imageView.image = UIImage(named: page?.imageName ?? "")
    }
}
