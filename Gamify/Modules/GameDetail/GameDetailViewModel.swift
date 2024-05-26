//  GameDetailViewModel.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 19.05.2024.
//

import Foundation

protocol GameDetailViewModelDelegate: AnyObject {
    func didLoadGameDetail(_ gameDetail: GameDetailResponse)
    func changeFavoriteButtonColor(isFavorite: Bool)
    func didLoadScreenshots()
}

protocol GameDetailViewModelProtocol {
    var delegate: GameDetailViewModelDelegate? { get set }
    var isFavorite: Bool { get }
    var screenshots: [Screenshot] { get }
    func loadGameDetail()
    func checkFavoriteStatus()
    func toggleFavoriteStatus()
}

final class GameDetailViewModel: GameDetailViewModelProtocol {
    weak var delegate: GameDetailViewModelDelegate?
    
    private var gameId: Int?
    private var currentGameDetail: GameDetailResponse?
    private var favoriteGame: FavoriteGame?
    private var gameListItem: GameListItem?
    
    var isFavorite: Bool {
        return favoriteGame != nil
    }
    
    var screenshots: [Screenshot] {
        return gameListItem?.screenshots ?? []
    }
    
    init(gameId: Int, gameListItem: GameListItem?) { 
        self.gameId = gameId
        self.gameListItem = gameListItem
    }
    
    func loadGameDetail() {
        guard let gameId = gameId else { return }
        
        let webService = WebService()
        webService.fetchGameDetail(gameId: gameId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let gameDetail):
                self.currentGameDetail = gameDetail
                self.delegate?.didLoadGameDetail(gameDetail)
                self.delegate?.didLoadScreenshots()
                self.checkFavoriteStatus()
            case .failure(let error):
                print("Error fetching game detail: \(error)")
            }
        }
    }
    
    func checkFavoriteStatus() {
        guard let gameDetail = currentGameDetail else { return }
        
        favoriteGame = CoreDataManager.shared.fetchFavoriteGame(withName: gameDetail.name)
        delegate?.changeFavoriteButtonColor(isFavorite: favoriteGame != nil)
    }
    
    func toggleFavoriteStatus() {
        guard let gameDetail = currentGameDetail else { return }
        
        if let favoriteGame = favoriteGame {
            CoreDataManager.shared.deleteFavoriteGame(favoriteGame)
            self.favoriteGame = nil
        } else {
            CoreDataManager.shared.saveFavoriteGame(gameDetail: gameDetail)
            self.favoriteGame = CoreDataManager.shared.fetchFavoriteGame(withName: gameDetail.name)
        }
        delegate?.changeFavoriteButtonColor(isFavorite: self.favoriteGame != nil)
    }
}
