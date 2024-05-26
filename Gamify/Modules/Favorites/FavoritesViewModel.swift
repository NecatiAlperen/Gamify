//
//  FavoritesViewModel.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 19.05.2024.
//

import Foundation

protocol FavoritesViewModelDelegate: AnyObject {
    func didUpdateFavorites()
    func didFailWithError(_ error: Error)
}

protocol FavoritesViewModelProtocol {
    var delegate: FavoritesViewModelDelegate? { get set }
    var favorites: [FavoriteGame] { get }
    func fetchFavorites()
    func deleteAllFavorites()
}

final class FavoritesViewModel {
    weak var delegate: FavoritesViewModelDelegate?
    private(set) var favorites: [FavoriteGame] = []
}

extension FavoritesViewModel: FavoritesViewModelProtocol {
    func fetchFavorites() {
        do {
            favorites = try CoreDataManager.shared.fetchFavorites()
            delegate?.didUpdateFavorites()
        } catch {
            delegate?.didFailWithError(error)
        }
    }
    
    func deleteAllFavorites() {
        do {
            try CoreDataManager.shared.deleteAllFavorites()
            favorites.removeAll()
            delegate?.didUpdateFavorites()
        } catch {
            delegate?.didFailWithError(error)
        }
    }
}


