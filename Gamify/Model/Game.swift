//  Game.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 19.05.2024.
//

import Foundation

// MARK: - GameListResponse
struct GameListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [GameListItem]
}

// MARK: - GameListItem
struct GameListItem: Codable {
    let id: Int?
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let screenshots: [Screenshot]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case screenshots = "short_screenshots"
    }
}

// MARK: - Screenshot
struct Screenshot: Codable {
    let id: Int
    let image: String
}

