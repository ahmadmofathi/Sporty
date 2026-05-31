//
//  SquadViewController.swift
//  sporty
//
//  Created by Shady Ramadan on 31/05/2026.
//

import UIKit

class SquadViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{
   
    @IBOutlet var squadTable: UITableView!
    let players: [(name: String, country: String,pos : String, age:Int,number : Int)] = [
        ("Shady","GK" ,"Egypt",27,10),
        ("fathy","GK" ,"Egypt",27,23)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("entered")
        squadTable.delegate = self
        squadTable.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return players.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PlayerCell",
            for: indexPath
        ) as? PlayerTableViewCell else {
            
            return UITableViewCell()
        }
        let players = players[indexPath.row]
        cell.playerName.text = players.name
        cell.playerInfo.text = "\(players.pos)  ·  \(players.country)  ·  \(players.age) years"
        cell.playerNumber.text = "\(players.number)"
        return cell
        
    }
}
