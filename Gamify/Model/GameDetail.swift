//
//  GameDetail.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 19.05.2024.
//




import Foundation

// MARK: - GameDetailResponse
struct GameDetailResponse: Codable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let description: String?
    let metacritic: Int?
    let playtime: Int?
    let genres: [GameDetailGenre]

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating, description, metacritic, playtime, genres
    }
}

// MARK: - GameDetailGenre
struct GameDetailGenre: Codable {
    let id: Int
    let name: String
}

