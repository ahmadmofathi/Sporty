import UIKit

class TennisPlayerCustomCell: UITableViewCell {

    @IBOutlet var season: UILabel!
    @IBOutlet var NumberOfTitles: UILabel!
    @IBOutlet var Rank: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureStat(with stat: YearlyStat) {
        let won = Int(stat.matchesWon ?? "0") ?? 0
        let lost = Int(stat.matchesLost ?? "0") ?? 0
        let typeLabel = stat.type == "singles" ? "Singles" : "Doubles"
        season.text = "Season \(stat.year ?? "-")  · \(typeLabel)"
        Rank.text = "🌐 Rank #\(stat.rank ?? "-")"
        NumberOfTitles.text = "✅ \(won)W  ❌ \(lost)L  🏆 \(stat.titles ?? "0")"
    }

    func configureTournament(with fixture: TennisFixture) {
        season.text = "\(fixture.title1 ?? "-") vs \(fixture.title2 ?? "-")"
        Rank.text = "📅 \(fixture.date ?? "-")"
        NumberOfTitles.text = "🏅 \(fixture.result ?? "-")"
    }

    func configureApiTournament(with tournament: TournamentStat) {
        season.text = tournament.name ?? "-"
        Rank.text = "🎾 \(tournament.surface ?? "-")  · \(tournament.season ?? "-")"
        NumberOfTitles.text = "💰 \(tournament.prize ?? "-")"
    }
}
