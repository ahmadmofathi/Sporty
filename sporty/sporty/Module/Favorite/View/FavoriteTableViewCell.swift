//
//  FavoriteTableViewCell.swift
//  sporty
//
//  Created by Ahmad on 21/05/2026.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var favImg: UIImageView!
    
    @IBOutlet weak var favOrigin: UILabel!
    @IBOutlet weak var favTitle: UILabel!


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
