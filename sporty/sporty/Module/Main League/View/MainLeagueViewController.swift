//
//  MainLeagueViewController.swift
//  sporty
//
//  Created by Ahmad on 26/05/2026.
//

import UIKit

class MainLeagueViewController: UIViewController {
    @IBOutlet var teamsCollectionView: UICollectionView!
    
    @IBOutlet var upComingCollectionView: UICollectionView!
    let upcomingEvents = [
            (
                team1: "Liverpool",
                team2: "Arsenal",
                score: "2 - 1",
                week: "Week 30"
            ),
            (
                team1: "Chelsea",
                team2: "Man City",
                score: "1 - 3",
                week: "Week 30"
            ),
            (
                team1: "Man United",
                team2: "Tottenham",
                score: "0 - 0",
                week: "Week 30"
            )
        ]

        let teams = [
            "Liverpool",
            "Arsenal",
            "Chelsea",
            "Man City",
            "Man United",
            "Tottenham"
        ]

        override func viewDidLoad() {
            super.viewDidLoad()

            upComingCollectionView.delegate = self
            upComingCollectionView.dataSource = self

            teamsCollectionView.delegate = self
            teamsCollectionView.dataSource = self
        }
    }
extension MainLeagueViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {

        if collectionView == upComingCollectionView {
            return upcomingEvents.count
        }

        return teams.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if collectionView == upComingCollectionView {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "UpComingEventCell",
                for: indexPath
            ) as! UpComingEventCellCollectionViewCell

            let event = upcomingEvents[indexPath.row]

            cell.team1Name.text = event.team1
            cell.team2Name.text = event.team2
            cell.eventDate.text = event.score
            cell.matchWeek.text = event.week

            cell.team1Img.image = UIImage(systemName: "sportscourt")
            cell.team2Img.image = UIImage(systemName: "sportscourt")

            return cell
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TeamCell",
            for: indexPath
        ) as! TeamCollectionViewCell

        cell.teamTitle.text = teams[indexPath.row]
        cell.teamLogo.image = UIImage(systemName: "shield.fill")

        return cell
    }
}
extension MainLeagueViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if collectionView == upComingCollectionView {

            return CGSize(
                width: collectionView.frame.width - 20,
                height: 180
            )
        }

        return CGSize(
            width: 80,
            height: 100
        )
    }
}
