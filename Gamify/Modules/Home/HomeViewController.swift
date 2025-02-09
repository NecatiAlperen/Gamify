//  HomeViewController.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 18.05.2024.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: -- VARIABLES
    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    // MARK: -- UI COMPONENTS
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.text = "Gamify"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        return pageControl
    }()
    private lazy var exploreAllLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Explore All Games"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GamesCell.self, forCellWithReuseIdentifier: "GamesCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var noResultView: NoResultView = {
        let noResultView = NoResultView()
        noResultView.isHidden = true
        noResultView.translatesAutoresizingMaskIntoConstraints = false
        return noResultView
    }()
    
    // MARK: -- LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureTitleLabel()
        configureSearchBar()
        configureScrollView()
        configurePageControl()
        configureExploreAllLabel()
        configureCollectionView()
        configureNoResultView()
        viewModel.loadGameList()
    }
    // MARK: -- FUNCTIONS
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    private func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4)
        ])
        
        setupScrollViewImages()
    }
    private func setupScrollViewImages() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        let images = viewModel.firstThreeImage
        for (index, game) in images.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.loadImage(from: game.backgroundImage)
            scrollView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * view.frame.width + 10)
            ])
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(images.count), height: scrollView.frame.height)
        pageControl.numberOfPages = images.count
    }
    private func configurePageControl() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 4),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    private func configureExploreAllLabel() {
        view.addSubview(exploreAllLabel)
        exploreAllLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exploreAllLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8),
            exploreAllLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: exploreAllLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }
    private func configureNoResultView() {
        view.addSubview(noResultView)
        NSLayoutConstraint.activate([
            noResultView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            noResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            noResultView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            noResultView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        let current = sender.currentPage
        let offset = CGPoint(x: CGFloat(current) * view.frame.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    private func showGameDetail(for game: GameListItem) {
        let detailVC = GameDetailViewController()
        detailVC.gameId = game.id
        detailVC.gameListItem = game
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
// MARK: -- EXTENSIONS
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        if pageWidth > 0 {
            let fractionalPage = scrollView.contentOffset.x / pageWidth
            let page = lround(Double(fractionalPage))
            pageControl.currentPage = page
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamesCell", for: indexPath) as! GamesCell
        if let gameList = viewModel.gameList(index: indexPath) {
            cell.configure(with: gameList)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedGame = viewModel.gameList(index: indexPath) {
            showGameDetail(for: selectedGame)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            viewModel.loadMoreGames()
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
        if !viewModel.isSearching {
            setupScrollViewImages()
            pageControl.numberOfPages = viewModel.firstThreeImage.count
        }
        
        if viewModel.numberOfItems == 0 && viewModel.isSearching {
            noResultView.isHidden = false
            collectionView.isHidden = true
            exploreAllLabel.isHidden = true
        } else {
            noResultView.isHidden = true
            collectionView.isHidden = false
            exploreAllLabel.isHidden = false
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            viewModel.searchGames(with: searchText)
            hideScrollViewAndPageControl()
            NSLayoutConstraint.deactivate(view.constraints.filter { $0.firstItem as? UIView == collectionView && $0.firstAttribute == .top })
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20)
            ])
        } else if searchText.isEmpty {
            viewModel.searchGames(with: "")
            showScrollViewAndPageControl()
            NSLayoutConstraint.deactivate(view.constraints.filter { $0.firstItem as? UIView == collectionView && $0.firstAttribute == .top })
            NSLayoutConstraint.activate([
                exploreAllLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8),
                collectionView.topAnchor.constraint(equalTo: exploreAllLabel.bottomAnchor, constant: 16)
            ])
            setupScrollViewImages()
            pageControl.numberOfPages = viewModel.firstThreeImage.count
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func hideScrollViewAndPageControl() {
        scrollView.isHidden = true
        pageControl.isHidden = true
    }
    
    private func showScrollViewAndPageControl() {
        scrollView.isHidden = false
        pageControl.isHidden = false
    }
}

