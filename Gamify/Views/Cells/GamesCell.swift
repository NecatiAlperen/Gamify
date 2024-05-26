//
//  GamesCell.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 19.05.2024.
//

import UIKit

final class GamesCell: UICollectionViewCell {
    
//MARK: -- UI COMPONENTS
    private lazy var gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        return imageView
    }()
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let gameRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var releasedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let gameReleasedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingImageView, gameRatingLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var releasedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [releasedImageView, gameReleasedLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingStackView, releasedStackView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [gameNameLabel, labelsStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
//MARK: -- LIFE CYCLES
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: -- FUNCTIONS
    private func setupViews() {
        contentView.addSubview(gameImageView)
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            gameImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            mainStackView.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 8),
            mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with model: GameListItem) {
        gameNameLabel.text = model.name
        gameRatingLabel.text = "\(model.rating)"
        gameReleasedLabel.text = model.released ?? "N/A"
        gameImageView.loadImage(from: model.backgroundImage)
    }
}

