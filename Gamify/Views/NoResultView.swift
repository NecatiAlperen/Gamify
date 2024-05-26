//
//  NoResultView.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 24.05.2024.
//



import UIKit

final class NoResultView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .noresult
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "No results found"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(messageLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: screenWidth * 0.8),
            imageView.heightAnchor.constraint(equalToConstant: screenHeigth * 0.5),
            
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func configure(image: UIImage?, message: String) {
        imageView.image = image
        messageLabel.text = message
    }
}

