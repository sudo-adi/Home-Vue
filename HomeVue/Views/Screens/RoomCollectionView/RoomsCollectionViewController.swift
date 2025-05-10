 //
//  RoomsCollectionViewController.swift
//  ProductDisplay
//
//  Created by Nishtha on 18/01/25.
//

import UIKit

private let reuseIdentifier = "RoomCell"

class RoomsCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var roomCategory :RoomCategory!
    var rooms:[RoomModel] = []
    private var searchController: SearchController<RoomModel>!
    private var emptyStateView: EmptyStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        setupNavigationBarAppearance()
        setupSearch()
        setupEmptyStateView()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            collectionView.addGestureRecognizer(longPressGesture)
        
        self.title = roomCategory.category.rawValue
        rooms = RoomDataProvider.shared.getRooms(for: roomCategory.category)
        searchController.updateItems(rooms)
        updateEmptyState()
    }
    
    private func setupSearch() {
        searchController = SearchController(
            hostViewController: self,
            collectionView: collectionView,
            initialItems: [],
            filterPredicate: { room, searchText in
                room.details.name.lowercased().contains(searchText.lowercased())
            },
            placeholder: "Search rooms..."
        )
    }
    
   func setupNavigationBarAppearance() {
       let appearance = UINavigationBarAppearance()
       appearance.configureWithOpaqueBackground()
       appearance.backgroundColor = .white
       appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
       appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
       appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
       UINavigationBar.appearance().standardAppearance = appearance
       UINavigationBar.appearance().scrollEdgeAppearance = appearance
       addBarButton.tintColor = .black
   }


    // MARK: Empty State Setup
    private func setupEmptyStateView() {
        emptyStateView = EmptyStateView(
            icon: UIImage(systemName: "house.fill"),
            message: "No rooms available.\nAdd a new room to get started!"
        )
        collectionView.addSubview(emptyStateView)
        
        // Constraints for emptyStateView
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 250),
            emptyStateView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        // Initially hidden
        emptyStateView.isHidden = true
    }
    
    private func updateEmptyState() {
        let isEmpty = searchController.filteredItems.isEmpty
        print("Updating empty state: filteredItems count = \(searchController.filteredItems.count), isEmpty = \(isEmpty)") // Debug log
        emptyStateView.isHidden = !isEmpty
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }
    
   func createLayout() -> UICollectionViewLayout {
       return UICollectionViewCompositionalLayout { sectionIndex, _ in
       let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
       let item = NSCollectionLayoutItem(layoutSize: itemSize)
       item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

       let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
       let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

       let section = NSCollectionLayoutSection(group: group)
       section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

       return section
       }
   }
    
    // MARK: Empty State Setup
    

   // MARK: UICollectionViewDataSource
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
   }

   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return searchController.filteredItems.count
   }

   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoomsCollectionViewCell
       let room = searchController.filteredItems[indexPath.item]
       cell.nameLabel.text = room.details.name
       cell.dateCreatedLabel?.text = "Created on : \(room.details.createdDate)"
       cell.roomImage.image = UIImage(named:"model_img")
       return cell
   }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if let tabBarController = self.tabBarController as? CustomTabBarController {
                tabBarController.showCustomAlert()
            }
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RoomsCollectionViewCell {
            if gesture.state == .began {
                // Add delete button to cell
                let deleteButton = UIButton(frame: CGRect(x: cell.bounds.width - 30, y: 5, width: 25, height: 25))
                deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
                deleteButton.tintColor = .red
                deleteButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                deleteButton.addCornerRadius(5)
                deleteButton.addTarget(self, action: #selector(deleteRoom(_:)), for: .touchUpInside)
                deleteButton.tag = indexPath.item
                cell.addSubview(deleteButton)
            }
        }
    }
    @objc func deleteRoom(_ sender: UIButton) {
        let index = sender.tag
        let roomToDelete = searchController.filteredItems[index]
        
        let alert = UIAlertController(
            title: "Delete Room",
            message: "Are you sure you want to delete \(roomToDelete.details.name)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Remove room from the RoomDataProvider
            RoomDataProvider.shared.removeRoom(from: RoomCategoryType(rawValue: roomToDelete.category.rawValue) ?? .bathroom, byId: roomToDelete.details.id)
            
            // 2. Get fresh data from provider
            let updatedRooms = RoomDataProvider.shared.getRooms(for: self.roomCategory.category)
            
            // 3. Update search controller
            self.searchController.updateItems(updatedRooms)
            
            self.collectionView.reloadData()
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
