//
//  EmptyStateView.swift
//  HomeVue
//
//  Created by Bhumi on 27/04/25.
//


import UIKit

class EmptyStateView: UIView {
    
    // MARK: - Properties
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(icon: UIImage?, message: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView(icon: icon, message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView(icon: UIImage?, message: String) {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        addSubview(iconImageView)
        addSubview(messageLabel)
        
        // Configure subviews
        iconImageView.image = icon
        messageLabel.text = message
        
        // Setup constraints
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 70),
            iconImageView.heightAnchor.constraint(equalToConstant: 70),
            
            messageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
        // Accessibility
        isAccessibilityElement = true
        accessibilityLabel = message
    }
    
    // MARK: - Configuration
    func configure(icon: UIImage?, message: String) {
        iconImageView.image = icon
        messageLabel.text = message
        accessibilityLabel = message
    }
}
