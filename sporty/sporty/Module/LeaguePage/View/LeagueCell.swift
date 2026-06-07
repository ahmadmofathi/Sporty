import UIKit

class LeagueCell: UITableViewCell {

    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet var liveBadegView: UIView!
    
    var onFavoriteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func favoriteButtonTapped() {
        onFavoriteTapped?()
    }
    
    func startFlashying(){
        self.liveBadegView.alpha = 1.0
        UIView.animate(withDuration: 0.8, delay: 0.0,
        options: [.repeat, .autoreverse, .allowUserInteraction],
                       animations: {
            self.liveBadegView.alpha = 0.2
        }, completion: nil)
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
