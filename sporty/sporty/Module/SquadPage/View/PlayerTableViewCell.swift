//
//  PlayerTableViewCell.swift
//  sporty
//
//  Created by Shady Ramadan on 31/05/2026.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var playerInfo: UILabel!
    @IBOutlet var playerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
