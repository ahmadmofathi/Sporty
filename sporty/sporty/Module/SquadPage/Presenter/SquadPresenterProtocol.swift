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
    func showNoInternet()
    func showEmptyState(message: String)
    func hideEmptyState()
}


