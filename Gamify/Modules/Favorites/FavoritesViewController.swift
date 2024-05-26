//
//  FavoritesViewController.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 18.05.2024.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: -- VARIABLES
    private var viewModel: FavoritesViewModelProtocol! = FavoritesViewModel()
    
    // MARK: -- UI COMPONENTS
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var noResultView: NoResultView = {
        let view = NoResultView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllFavorites))
        button.isEnabled = false
        return button
    }()
    
    // MARK: -- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Favorites"
        viewModel.delegate = self
        setupCollectionView()
        setupNoResultView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
    }
    
    // MARK: -- FUNCTIONS
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
    
    private func setupNoResultView() {
        view.addSubview(noResultView)
        
        NSLayoutConstraint.activate([
            noResultView.topAnchor.constraint(equalTo: view.topAnchor),
            noResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noResultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noResultView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = deleteAllButton
    }
    
    @objc private func deleteAllFavorites() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to remove all favorites?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
            self.viewModel.deleteAllFavorites()
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: -- EXTENSIONS
extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.favorites.count
        noResultView.isHidden = count != 0
        collectionView.isHidden = count == 0
        deleteAllButton.isEnabled = count != 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamesCell", for: indexPath) as! GamesCell
        let favoriteGame = viewModel.favorites[indexPath.item]
        let gameListItem = GameListItem(
            id: 0,
            name: favoriteGame.name ?? "",
            released: favoriteGame.releaseDate,
            backgroundImage: favoriteGame.backgroundImageURL ?? "",
            rating: favoriteGame.rating,
            screenshots: []
        )
        cell.configure(with: gameListItem)
        return cell
    }
}

extension FavoritesViewController: FavoritesViewModelDelegate {
    func didUpdateFavorites() {
        collectionView.reloadData()
        if viewModel.favorites.isEmpty {
            noResultView.configure(image: UIImage(named: "nofavorite"), message: "No favorites found")
            noResultView.isHidden = false
            collectionView.isHidden = true
        } else {
            noResultView.isHidden = true
            collectionView.isHidden = false
        }
        deleteAllButton.isEnabled = !viewModel.favorites.isEmpty
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    func didFailWithError(_ error: Error) {
        print("Failed to fetch favorites: \(error)")
    }
}

