//
//  FavoritesCollectionViewController.swift
//  HomeVue
//
//  Created by Bhumi on 21/04/25.
//

import UIKit
import SwiftUI

private let reuseIdentifier = "ItemCollectionViewCell"

class FavoritesCollectionViewController: UICollectionViewController {

    private var favoriteItems: [FurnitureItem] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigationBarAppearance()
            setupCollectionView()
            fetchFavoriteItems()
            
            navigationController?.navigationBar.barTintColor = .white
            self.title = "Favorites"
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchFavoriteItems()
            collectionView.reloadData()
            print("FavoritesViewController viewWillAppear: Refreshed items")
        }
        
        private func fetchFavoriteItems() {
            // Fetch favorite items
            favoriteItems = UserDetails.shared.getFavoriteFurnitures()
            print("Fetched favorites: \(favoriteItems.map { "\($0.name): \($0.id), IsFavorite: \(UserDetails.shared.isFavoriteFurniture(furnitureID: $0.id))" })")
        }
        
        private func setupCollectionView() {
//            collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
            collectionView.collectionViewLayout = createLayout()
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
        
        // MARK: - Compositional Layout
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

        // MARK: - UICollectionViewDataSource
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
            performSegue(withIdentifier: "showProductInfoSegue", sender: selectedItem)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showProductInfoSegue", let item = sender as? FurnitureItem {
                if let destinationVC = segue.destination as? ProductInfoTableViewController {
                    destinationVC.furnitureItem = item
                } else {
                    print("Destination view controller is not of type ProductInfoTableViewController")
                }
            } else {
                print("Invalid segue identifier or sender is not a FurnitureItem")
            }
        }
        
        private func toggleFavorite(furnitureItem: FurnitureItem) {
            UserDetails.shared.toggleSave(furnitureItem: furnitureItem)
            fetchFavoriteItems()
            collectionView.reloadData()
        }

}
