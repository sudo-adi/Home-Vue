import UIKit

class SearchBarView: UIView {
    var onTextChanged: ((String) -> Void)?
    var onCancelTapped: (() -> Void)?
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search..."
        sb.searchBarStyle = .minimal
        sb.showsCancelButton = true
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        searchBar.delegate = self
//        backgroundColor = .systemGray6
        backgroundColor = UIColor(white: 0.95, alpha: 1.0) // Light gray background
        
        searchBar.overrideUserInterfaceStyle = .light
        searchBar.tintColor = UIColor.darkGray
        searchBar.searchTextField.textColor = UIColor.black
    }
    
    func setPlaceholder(_ text: String) {
        searchBar.placeholder = text
    }
}

extension SearchBarView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onTextChanged?(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        onCancelTapped?()
    }
}


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
            filteredItems = allItems.filter { item in
                filterPredicate(item, searchText)
            }
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


class SearchController<T> {
    public let searchBarView: SearchBarView
    private var searchHandler: SearchHandler<T>
    private let collectionView: UICollectionView
    
    init(collectionView: UICollectionView,
         initialItems: [T],
         filterPredicate: @escaping (T, String) -> Bool,
         placeholder: String = "Search...") {
        
        self.collectionView = collectionView
        self.searchHandler = SearchHandler(items: initialItems, filterPredicate: filterPredicate)
        
        searchBarView = SearchBarView()
        searchBarView.setPlaceholder(placeholder)
        
        setupSearchBar()
        setupHandlers()
    }
    
    private func setupSearchBar() {
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = collectionView.superview else { return }
        
        superview.addSubview(searchBarView)
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        collectionView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
    }
    
    private func setupHandlers() {
        searchBarView.onTextChanged = { [weak self] text in
            self?.searchHandler.filterItems(with: text)
            self?.collectionView.reloadData()
        }
        
        searchBarView.onCancelTapped = { [weak self] in
            self?.searchHandler.resetSearch()
            self?.collectionView.reloadData()
        }
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
}

