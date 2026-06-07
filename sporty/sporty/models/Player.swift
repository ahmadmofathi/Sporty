struct Player: Codable {
    let playerName: String?
    let playerType: String?
    let playerAge: String?
    let playerNumber: String?
    let playerCountry: String?
    let playerImage: String?
    
    enum CodingKeys: String, CodingKey {
        case playerName = "player_name"
        case playerType = "player_type"
        case playerAge = "player_age"
        case playerNumber = "player_number"
        case playerCountry = "player_country"
        case playerImage = "player_image"
    }
}
