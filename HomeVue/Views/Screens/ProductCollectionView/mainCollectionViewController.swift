import UIKit
import SwiftUI

private let reuseIdentifier = "ItemCollectionViewCell"

class mainCollectionViewController: UICollectionViewController {
    var furnitureCategory: FurnitureCategory?
    private var searchController: SearchController<FurnitureItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
        fetchItemsForCategory()
        setupCollectionView()
        
        navigationController?.navigationBar.barTintColor = .white
        self.title = furnitureCategory?.category.rawValue
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCollection), name: NSNotification.Name("FavoriteToggled"), object: nil)
    }
    
    @objc private func refreshCollection() {
        collectionView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarAppearance()
        fetchItemsForCategory()
        collectionView.reloadData()
    }
    
    func fetchItemsForCategory() {
        guard let categoryType = furnitureCategory?.category else { return }
        
        // Fetch furniture items
        let items = FurnitureDataProvider.shared.fetchFurnitureItems(for: categoryType)
        
        // Update the search controller with these items
        searchController = SearchController(
            collectionView: collectionView,
            initialItems: items,
            filterPredicate: { item, text in
                item.name.lowercased().contains(text.lowercased()) ||
                item.brandName.lowercased().contains(text.lowercased())
            },
            placeholder: "Search furniture..."
        )
        
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .black  // Back button color
        navigationController?.navigationBar.prefersLargeTitles = false
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
        return searchController.filteredItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Unable to dequeue ItemCollectionViewCell")
        }
        
        let item = searchController.filteredItems[indexPath.item]
        cell.configure(with: item, favoriteToggleAction: { [weak self] furnitureItem in
            self?.toggleFavorite(furnitureItem: furnitureItem)
        }, arButtonAction: { [weak self] furnitureItem in
            ARViewPresenter.presentARView(for: furnitureItem, allowBrowse: false, from: self!)
        })
        print("Item: \(item.name), ID: \(item.id), IsFavorite: \(UserDetails.shared.isFavoriteFurniture(furnitureID: item.id))")
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = searchController.filteredItems[indexPath.item]
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
        // Toggle favorite status
        UserDetails.shared.toggleSave(furnitureItem: furnitureItem)
        // Refresh items to update favorite status
        collectionView.reloadData()
    }
}
