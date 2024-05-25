//
//  GameDetailViewModel.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 19.05.2024.
//

import Foundation

protocol GameDetailViewModelDelegate: AnyObject {
    func didLoadGameDetail(_ gameDetail: GameDetailResponse)
    func changeFavoriteButtonColor(isFavorite: Bool)
}

protocol GameDetailViewModelProtocol {
    var delegate: GameDetailViewModelDelegate? { get set }
    func loadGameDetail()
    func checkFavoriteStatus()
    func toggleFavoriteStatus()
}

final class GameDetailViewModel: GameDetailViewModelProtocol {
    weak var delegate: GameDetailViewModelDelegate?
    
    private var gameId: Int?
    private var currentGameDetail: GameDetailResponse?
    
    init(gameId: Int) {
        self.gameId = gameId
    }
    
    func loadGameDetail() {
        guard let gameId = gameId else { return }
        
        let webService = WebService()
        webService.fetchGameDetail(gameId: gameId) { [weak self] result in
            switch result {
            case .success(let gameDetail):
                self?.currentGameDetail = gameDetail
                self?.delegate?.didLoadGameDetail(gameDetail)
                self?.checkFavoriteStatus() 
            case .failure(let error):
                print("Error fetching game detail: \(error)")
            }
        }
    }
    
    func checkFavoriteStatus() {
        guard let gameDetail = currentGameDetail else { return }
        
        let favoriteGame = CoreDataManager.shared.fetchFavoriteGame(withName: gameDetail.name)
        delegate?.changeFavoriteButtonColor(isFavorite: favoriteGame != nil)
    }
    
    func toggleFavoriteStatus() {
        guard let gameDetail = currentGameDetail else { return }
        
        if let favoriteGame = CoreDataManager.shared.fetchFavoriteGame(withName: gameDetail.name) {
            CoreDataManager.shared.deleteFavoriteGame(favoriteGame)
            delegate?.changeFavoriteButtonColor(isFavorite: false)
        } else {
            CoreDataManager.shared.saveFavoriteGame(gameDetail: gameDetail)
            delegate?.changeFavoriteButtonColor(isFavorite: true)
        }
    }
}




