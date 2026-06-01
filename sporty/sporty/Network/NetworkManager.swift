import Foundation
import Alamofire

class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    func fetchLeagues(
        sport: String,
        completion: @escaping (Result<[League], Error>) -> Void
    ) {
        // 1️⃣ صلحنا الـ API Key وشيلنا الشرطة الغلط ورجعنا حرف الـ c
        let apiKey = "53b3a058aedc852b1c141bc3c80078695068dc06342a6e408e3a390a7252cd27"

        // 2️⃣ حولنا اسم الرياضة لـ سمول تماماً قبل ما يدخل في الـ URL لمنع الـ 404
        let safeSport = sport.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        let url = "https://apiv2.allsportsapi.com/\(safeSport)/?met=Leagues&APIkey=\(apiKey)"

        // سطر الـ print ده هيريحك ويوريك الـ URL النهائي في الـ Console
        print("🚀 Sending Request to URL: \(url)")

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
