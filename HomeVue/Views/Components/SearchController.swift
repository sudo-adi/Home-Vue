import UIKit
import Foundation

class SearchHandler<T> {
    var allItems: [T]
    var filteredItems: [T]
    let filterPredicate: (T, String) -> Bool

    init(items: [T], filterPredicate: @escaping (T, String) -> Bool) {
        self.allItems = items
        self.filteredItems = items
        self.filterPredicate = filterPredicate
    }

    func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter { filterPredicate($0, searchText) }
        }
    }

    func resetSearch() {
        filteredItems = allItems
    }

    func updateItems(_ newItems: [T]) {
        allItems = newItems
        filteredItems = newItems
    }
}

class SearchController<T>: NSObject, UISearchResultsUpdating {
    private let searchHandler: SearchHandler<T>
    private let collectionView: UICollectionView
    private unowned let hostViewController: UIViewController
    private let searchController: UISearchController

    init(
        hostViewController: UIViewController,
        collectionView: UICollectionView,
        initialItems: [T],
        filterPredicate: @escaping (T, String) -> Bool,
        placeholder: String = "Search..."
    ) {
        self.collectionView = collectionView
        self.hostViewController = hostViewController
        self.searchHandler = SearchHandler(items: initialItems, filterPredicate: filterPredicate)

        self.searchController = UISearchController(searchResultsController: nil)
        super.init()
        
        setupSearchController(placeholder: placeholder)
    }

    private func setupSearchController(placeholder: String) {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = placeholder
        searchController.hidesNavigationBarDuringPresentation = true

        hostViewController.navigationItem.searchController = searchController
        hostViewController.definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        searchHandler.filterItems(with: searchText)
        collectionView.reloadData()
    }

    var allItems: [T] {
        return searchHandler.allItems
    }

    var filteredItems: [T] {
        return searchHandler.filteredItems
    }

    func updateItems(_ newItems: [T]) {
        searchHandler.updateItems(newItems)
        collectionView.reloadData()
    }

    func deactivateSearch() {
        searchController.isActive = false
    }
}
