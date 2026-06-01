//
//  NetworkManager.swift
//  sporty
//
//  Created by Ahmad on 01/06/2026.
//

import Foundation
import Alamofire

class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    func fetchLeagues(
        sport: String,
        completion: @escaping (Result<[League], Error>) -> Void
    ) {

        let apiKey = "PUT_YOUR_API_KEY_HERE"

        let url =
        "https://apiv2.allsportsapi.com/\(sport)/?met=Leagues&APIkey=\(apiKey)"

        AF.request(url)
            .validate()
            .responseDecodable(of: LeaguesResponse.self) { response in

                switch response.result {

                case .success(let data):
                    completion(.success(data.result))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
