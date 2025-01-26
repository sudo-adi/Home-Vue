import UIKit

private let reuseIdentifier = "ItemCollectionViewCell"

class mainCollectionViewController: UICollectionViewController {

    var furnitureCategory: FurnitureCategory?
    var furnitureItems: [FurnitureItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
        navigationController?.navigationBar.barTintColor = .white
        collectionView.collectionViewLayout = createLayout()
        self.title = furnitureCategory?.category.rawValue
        if let furnitureCategory = furnitureCategory {
            furnitureItems = furnitureCategory.furnitureItems
        } else {
            print("Furniture category is nil")
        }
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
        return furnitureItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Unable to dequeue ItemCollectionViewCell")
        }
        
        let item = furnitureItems[indexPath.item]
        configure(cell: cell, with: item)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = furnitureItems[indexPath.item]
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
