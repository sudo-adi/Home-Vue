import UIKit
import SwiftUI

private let reuseIdentifier = "ItemCollectionViewCell"

class FavoritesCollectionViewController: UICollectionViewController {
    
    private var favoriteItems: [FurnitureItem] = []
    private var emptyStateView: EmptyStateView!
    
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
        emptyStateView = EmptyStateView(
            icon: UIImage(systemName: "heart.slash"),
            message: "No Favorites Yet\nItems you save will appear here"
        )
        view.addSubview(emptyStateView)
        
        // Constraints for emptyStateView
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 250),
            emptyStateView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        // Initially hidden if there are favorite items
        emptyStateView.isHidden = true
    }
    
    private func updateEmptyStateVisibility() {
        emptyStateView.isHidden = !favoriteItems.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarAppearance()
        fetchFavoriteItems()
        collectionView.reloadData()
        print("FavoritesViewController viewWillAppear: Refreshed items")
    }
    
    private func fetchFavoriteItems() {
        favoriteItems = UserDetails.shared.getFavoriteFurnitures()
        updateEmptyStateVisibility()
        print("Fetched favorites: \(favoriteItems.map { "\($0.name!): \(String(describing: $0.id!)), IsFavorite: \(UserDetails.shared.isFavoriteFurniture(furnitureID: $0.id!))" })")
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = createLayout()
//        collectionView.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
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
        print("Cell for item: \(item.name!), ID: \(item.id!), IsFavorite: \(UserDetails.shared.isFavoriteFurniture(furnitureID: item.id!))")
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
