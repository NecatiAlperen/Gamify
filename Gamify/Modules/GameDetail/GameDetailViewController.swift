//  GameDetailViewController.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 18.05.2024.
//


import UIKit

final class GameDetailViewController: UIViewController {
    
    // MARK: -- VARIABLES
    var gameId: Int?
    var gameListItem: GameListItem?
    private var currentGameDetail: GameDetailResponse?
    var viewModel: GameDetailViewModelProtocol!
    
    // MARK: -- UI COMPONENTS
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var favoriteButtonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image = UIImage(systemName: "heart.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var gameReleaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var metacriticRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var moreAboutGameLabel: UILabel = {
        let label = UILabel()
        label.text = "More About Game"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var descriptionOfGameLabel: UILabel = {
        let label = UILabel()
        label.text = "Description Of Game"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var gameDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [gameReleaseLabel, metacriticRateLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [gameNameLabel, infoStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var screenshotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 200, height: 120)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: "ScreenshotCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: -- LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteStatus), name: NSNotification.Name("FavoritesUpdated"), object: nil)
        
        if let gameId = gameId {
            viewModel = GameDetailViewModel(gameId: gameId, gameListItem: gameListItem)
            viewModel.delegate = self
            viewModel.loadGameDetail()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -- FUNCTIONS
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(gameImageView)
        contentView.addSubview(favoriteButtonBackgroundView)
        favoriteButtonBackgroundView.addSubview(favoriteButton)
        contentView.addSubview(mainStackView)
        contentView.addSubview(moreAboutGameLabel)
        contentView.addSubview(screenshotsCollectionView)
        contentView.addSubview(descriptionOfGameLabel)
        contentView.addSubview(gameDescriptionLabel)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gameImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
            
            favoriteButtonBackgroundView.bottomAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: -8),
            favoriteButtonBackgroundView.trailingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: -8),
            favoriteButtonBackgroundView.widthAnchor.constraint(equalToConstant: 40),
            favoriteButtonBackgroundView.heightAnchor.constraint(equalToConstant: 40),
            
            favoriteButton.centerXAnchor.constraint(equalTo: favoriteButtonBackgroundView.centerXAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: favoriteButtonBackgroundView.centerYAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            moreAboutGameLabel.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 16),
            moreAboutGameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            moreAboutGameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            screenshotsCollectionView.topAnchor.constraint(equalTo: moreAboutGameLabel.bottomAnchor, constant: 16),
            screenshotsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            screenshotsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            screenshotsCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            descriptionOfGameLabel.topAnchor.constraint(equalTo: screenshotsCollectionView.bottomAnchor, constant: 16),
            descriptionOfGameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionOfGameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            gameDescriptionLabel.topAnchor.constraint(equalTo: descriptionOfGameLabel.bottomAnchor, constant: 8),
            gameDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gameDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            gameDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureView(with gameDetail: GameDetailResponse) {
        currentGameDetail = gameDetail
        
        gameNameLabel.text = gameDetail.name
        gameReleaseLabel.text = "Release Date: \(gameDetail.released ?? "")"
        metacriticRateLabel.text = "Metacritic: \(gameDetail.metacritic ?? 0)"
        gameDescriptionLabel.text = gameDetail.description?.stringByRemovingHTMLTags() ?? "No description available."
        gameImageView.loadImage(from: gameDetail.backgroundImage)
        self.title = gameDetail.name
        
        viewModel.checkFavoriteStatus()
    }
    
    @objc private func favoriteButtonTapped() {
        if viewModel.isFavorite {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to remove the game from favorites?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                self.viewModel.toggleFavoriteStatus()
            }))
            present(alert, animated: true, completion: nil)
        } else {
            viewModel.toggleFavoriteStatus()
        }
    }
    
    @objc private func updateFavoriteStatus() {
        viewModel.checkFavoriteStatus()
    }
}
// MARK: -- EXTENSIONS

extension GameDetailViewController: GameDetailViewModelDelegate {
    func didLoadGameDetail(_ gameDetail: GameDetailResponse) {
        configureView(with: gameDetail)
    }
    
    func changeFavoriteButtonColor(isFavorite: Bool) {
        favoriteButton.tintColor = isFavorite ? .red : .white
    }
    
    func didLoadScreenshots() {
        screenshotsCollectionView.reloadData()
    }
}

extension GameDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotCell", for: indexPath) as! ScreenshotCell
        let screenshot = viewModel.screenshots[indexPath.item]
        cell.configure(with: screenshot)
        return cell
    }
}
