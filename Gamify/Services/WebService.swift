//
//  WebService.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 19.05.2024.
//

import Foundation
import Alamofire

class WebService {
    
    private let apiKey = "9e695f35cca74deca083634327de5b5c"
    
    func fetchGameList(page: Int = 1, completion: @escaping (Result<[GameListItem], Error>) -> Void) {
        let url = "https://api.rawg.io/api/games?key=\(apiKey)&page=\(page)"
        print("asdas")
        AF.request(url).responseDecodable(of: GameListResponse.self) { response in
            switch response.result {
            case .success(let gameListResponse):
                completion(.success(gameListResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GameDetailResponse, Error>) -> Void) {
        let url = "https://api.rawg.io/api/games/\(gameId)?key=\(apiKey)"
        
        AF.request(url).responseDecodable(of: GameDetailResponse.self) { response in
            switch response.result {
            case .success(let gameDetailResponse):
                completion(.success(gameDetailResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

