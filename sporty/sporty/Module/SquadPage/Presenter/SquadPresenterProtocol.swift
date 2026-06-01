//
//  SquadPresenterProtocol.swift
//  sporty
//
//  Created by Ahmad on 01/06/2026.
//
import Foundation

protocol SquadViewProtocol: AnyObject {

    func renderPlayers()

    func showError(message: String)
}

protocol SquadPresenterProtocol {

    var players: [Player] { get }

    func getPlayers(teamId: Int)
}
