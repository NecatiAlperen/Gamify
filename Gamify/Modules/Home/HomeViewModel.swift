//  HomeViewModel.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 19.05.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func reloadData()
    func didFailWithError(_ error: Error)
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var firstThreeImage: [GameListItem] { get }
    var isSearching: Bool { get }
    
    func loadGameList()
    func loadMoreGames()
    func gameList(index: IndexPath) -> GameListItem?
    func searchGames(with query: String)
    func resetGames()
    
}

final class HomeViewModel {
    
    private var games: [GameListItem] = []
    private var filteredGames: [GameListItem] = []
    private let webService = WebService()
    weak var delegate: HomeViewModelDelegate?
    private var currentPage = 1
    private var isLoading = false
    private var searching = false
    
    var firstThreeImage: [GameListItem] {
        return Array(games.prefix(3))
    }
    
    var isSearching: Bool {
        return searching
    }
    
    fileprivate func fetchGameList(page: Int) {
        isLoading = true
        webService.fetchGameList(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let games):
                self.games.append(contentsOf: games)
                DispatchQueue.main.async {
                    self.delegate?.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }

    func searchGames(with query: String) {
        if query.count < 3 {
            searching = false
            filteredGames = []
        } else {
            searching = true
            filteredGames = games.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
        delegate?.reloadData()
    }

    func resetGames() {
        games = []
        currentPage = 1
        fetchGameList(page: currentPage)
    }
}

extension HomeViewModel: HomeViewModelProtocol {
        
    var numberOfItems: Int {
        return searching ? filteredGames.count : games.count
    }
    
    func loadGameList() {
        fetchGameList(page: currentPage)
    }
    
    func loadMoreGames() {
        guard !isLoading else { return }
        currentPage += 1
        fetchGameList(page: currentPage)
    }
    
    func gameList(index: IndexPath) -> GameListItem? {
        let currentGames = searching ? filteredGames : games
        guard index.item < currentGames.count else { return nil }
        return currentGames[index.item]
    }
}

