
import UIKit

private let reuseIdentifier = "ItemCollectionViewCell"

class mainCollectionViewController: UICollectionViewController {
    
    var furnitureCategory: FurnitureCategory?
    private var searchController: SearchController<FurnitureItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
        setupSearch()
        setupCollectionView()
        
        navigationController?.navigationBar.barTintColor = .white
        self.title = furnitureCategory?.category.rawValue
    }
    
    private func setupSearch() {
        guard let furnitureItems = furnitureCategory?.furnitureItems else {
            print("Furniture category is nil")
            return
        }
        
        searchController = SearchController(
            collectionView: collectionView,
            initialItems: furnitureItems,
            filterPredicate: { item, text in
                item.name.lowercased().contains(text.lowercased()) ||
                item.brandName.lowercased().contains(text.lowercased())
            },
            placeholder: "Search furniture..."
        )
    }
    
    private func setupCollectionView() {
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
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
        configure(cell: cell, with: item)
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
    
    func configure(cell: ItemCollectionViewCell, with item: FurnitureItem) {
        cell.ProductImg?.image = item.image ?? UIImage(named: "placeholder")
        cell.ProductName?.text = item.name
    }
}
