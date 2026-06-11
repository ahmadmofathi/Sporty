//
//  ViewController.swift
//  sporty
//
//  Created by Ahmad on 21/05/2026.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "MainLeague", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MainLeagueViewController") as? MainLeagueViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }


}

