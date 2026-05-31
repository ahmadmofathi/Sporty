//
//  LeagueCell.swift
//  sporty
//
//  Created by Shady Ramadan on 25/05/2026.
//

import UIKit

class LeagueCell: UITableViewCell {

    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet var liveBadegView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool,
                              animated: Bool) {

        super.setSelected(selected,
                          animated: animated)
    }
    func startFlashying(){
        self.liveBadegView.alpha=1.0
        UIView.animate(withDuration: 0.8, delay: 0.0,
        options: [.repeat,.autoreverse,.allowUserInteraction],
                       animations: {
            self.liveBadegView.alpha = 0.2
        }, completion : nil )
    }
    func stopFlashing(){
        self.liveBadegView.layer.removeAllAnimations()
        self.liveBadegView.alpha = 1.0
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        stopFlashing()
    }
}

