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
        let storyboard = UIStoryboard(name: "Favorites", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoritesTableViewController
        navigationController?.pushViewController(vc, animated: true)
    }


}

