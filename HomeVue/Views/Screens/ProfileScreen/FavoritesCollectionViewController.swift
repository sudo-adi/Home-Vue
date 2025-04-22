import UIKit
import SwiftUI

private let reuseIdentifier = "ItemCollectionViewCell"

class FavoritesCollectionViewController: UICollectionViewController {
    
    private var favoriteItems: [FurnitureItem] = []
    private var emptyStateView: UIView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigationBarAppearance()
            setupCollectionView()
            setupEmptyStateView()
            fetchFavoriteItems()
            
            NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites), name: NSNotification.Name("FavoriteToggled"), object: nil)
            
            navigationController?.navigationBar.barTintColor = .white
            self.title = "Favorites"
        }
        
        @objc private func refreshFavorites() {
            fetchFavoriteItems()
            collectionView.reloadData()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
    private func setupEmptyStateView() {
        emptyStateView = UIView()
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 250),
            emptyStateView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        let iconImageView = UIImageView(image: UIImage(systemName: "heart.slash"))
        iconImageView.tintColor = .systemGray2
        iconImageView.contentMode = .scaleAspectFit
        emptyStateView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = "No Favorites Yet\nItems you save will appear here"
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = .systemGray2
        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emptyStateView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 70),
            iconImageView.heightAnchor.constraint(equalToConstant: 70),
            
            messageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: emptyStateView.bottomAnchor)
        ])
    }
    
    private func updateEmptyStateVisibility() {
        emptyStateView.isHidden = !favoriteItems.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteItems()
        collectionView.reloadData()
        print("FavoritesViewController viewWillAppear: Refreshed items")
    }
    
    private func fetchFavoriteItems() {
        favoriteItems = UserDetails.shared.getFavoriteFurnitures()
        updateEmptyStateVisibility()
        print("Fetched favorites: \(favoriteItems.map { "\($0.name): \($0.id), IsFavorite: \(UserDetails.shared.isFavoriteFurniture(furnitureID: $0.id))" })")
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Unable to dequeue ItemCollectionViewCell")
        }
        
        let item = favoriteItems[indexPath.item]
        cell.configure(with: item, favoriteToggleAction: { [weak self] furnitureItem in
            self?.toggleFavorite(furnitureItem: furnitureItem)
        }, arButtonAction: { [weak self] furnitureItem in
            ARViewPresenter.presentARView(for: furnitureItem, allowBrowse: false, from: self!)
        })
        print("Cell for item: \(item.name), ID: \(item.id), IsFavorite: \(UserDetails.shared.isFavoriteFurniture(furnitureID: item.id))")
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = favoriteItems[indexPath.item]
        
        let productStoryboard = UIStoryboard(name: "ProductDisplay", bundle: nil)
        
        if let productInfoVC = productStoryboard.instantiateViewController(withIdentifier: "ProductInfoTableViewController") as? ProductInfoTableViewController {
            productInfoVC.furnitureItem = selectedItem
            productInfoVC.modalPresentationStyle = .fullScreen
            present(productInfoVC, animated: true)
        }
    }
    
    private func toggleFavorite(furnitureItem: FurnitureItem) {
        UserDetails.shared.toggleSave(furnitureItem: furnitureItem)
        fetchFavoriteItems()
        collectionView.reloadData()
    }
}
