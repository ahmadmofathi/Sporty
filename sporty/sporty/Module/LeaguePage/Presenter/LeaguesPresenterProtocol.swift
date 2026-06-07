//
//  LeaguesViewProtocol.swift
//  sporty
//
//  Created by Ahmad on 01/06/2026.
//

import Foundation

protocol LeaguesViewProtocol: AnyObject {

    func renderLeagues()

    func showError(message: String)
}

protocol LeaguesPresenterProtocol {

    func getLeagues()

    var leagues: [League] { get }
}
