//
//  FavoritesViewController.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 18.05.2024.
//



import UIKit

final class FavoritesViewController: UIViewController {
    
    private var viewModel: FavoritesViewModelProtocol! = FavoritesViewModel()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Favorites"
        viewModel.delegate = self
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.register(GamesCell.self, forCellWithReuseIdentifier: "GamesCell")
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamesCell", for: indexPath) as! GamesCell
        let favoriteGame = viewModel.favorites[indexPath.item]
        let gameListItem = GameListItem(
            id: 0,
            name: favoriteGame.name ?? "",
            released: favoriteGame.releaseDate,
            backgroundImage: favoriteGame.backgroundImageURL ?? "",
            rating: favoriteGame.rating
        )
        cell.configure(with: gameListItem)
        return cell
    }
}

extension FavoritesViewController: FavoritesViewModelDelegate {
    func didUpdateFavorites() {
        collectionView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        print("Failed to fetch favorites: \(error)")
    }
}
