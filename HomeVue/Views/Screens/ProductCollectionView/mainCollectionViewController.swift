import UIKit

private let reuseIdentifier = "ItemCollectionViewCell"

class mainCollectionViewController: UICollectionViewController, UISearchBarDelegate {

    var furnitureCategory: FurnitureCategory?
    var furnitureItems: [FurnitureItem] = []
    
    // Add filtered items array
    private var filteredFurnitureItems: [FurnitureItem] = []
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
        setupSearchBar()
        
        navigationController?.navigationBar.barTintColor = .white
        collectionView.collectionViewLayout = createLayout()
        self.title = furnitureCategory?.category.rawValue
        if let furnitureCategory = furnitureCategory {
            furnitureItems = furnitureCategory.furnitureItems
            filteredFurnitureItems = furnitureItems
        } else {
            print("Furniture category is nil")
        }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
            searchBar.placeholder = "Search furniture..."
            searchBar.searchBarStyle = .minimal
            searchBar.showsCancelButton = true
            searchBar.sizeToFit()
            
            // Add search bar as header view of collection view
        collectionView.contentInset = UIEdgeInsets(top: searchBar.frame.height, left: 0, bottom: 0, right: 0)
            collectionView.addSubview(searchBar)
            
            // Position search bar
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: collectionView.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
            ])
    }
    
    func setupNavigationBarAppearance() {
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
        return filteredFurnitureItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Unable to dequeue ItemCollectionViewCell")
        }
        
        let item = filteredFurnitureItems[indexPath.item]
        configure(cell: cell, with: item)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = filteredFurnitureItems[indexPath.item]
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
    
    // Add UISearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredFurnitureItems = furnitureItems
        } else {
            filteredFurnitureItems = furnitureItems.filter { item in
                item.name.lowercased().contains(searchText.lowercased()) ||
                item.brandName.lowercased().contains(searchText.lowercased()) ||
                item.description.lowercased().contains(searchText.lowercased())
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredFurnitureItems = furnitureItems
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
}
