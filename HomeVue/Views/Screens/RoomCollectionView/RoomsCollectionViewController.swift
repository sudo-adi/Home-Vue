//
//  RoomsCollectionViewController.swift
//  ProductDisplay
//
//  Created by Nishtha on 18/01/25.
//

import UIKit

private let reuseIdentifier = "RoomCell"

class RoomsCollectionViewController: UICollectionViewController {
    var rooms: [(name: String, date: String, image: UIImage, id: UUID, category: String)] = [
        (name: "Room 2", date: "3rd Oct 2024", image: UIImage(named: "model_img") ?? UIImage(), id: UUID(), category: "Living Room"),
        (name: "Room 1", date: "5th Oct 2024", image: UIImage(named: "model_img") ?? UIImage(), id: UUID(), category: "Bedroom"),
        (name: "Room 3", date: "10th Oct 2024", image: UIImage(named: "model_img") ?? UIImage(), id: UUID(), category: "Kitchen")
    ]
        var roomCategory :RoomCategory!
  //    var rooms:[RoomModel] = []

            override func viewDidLoad() {
                super.viewDidLoad()
                collectionView.collectionViewLayout = createLayout()
                setupNavigationBarAppearance()
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
                    collectionView.addGestureRecognizer(longPressGesture)
//                self.title = roomCategory.category.rawValue
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

           // MARK: UICollectionViewDataSource
           override func numberOfSections(in collectionView: UICollectionView) -> Int {
               return 1
           }

           override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
               return rooms.count
           }

           override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoomsCollectionViewCell
               let room = rooms[indexPath.item]
               cell.nameLabel.text = room.name
               cell.dateCreatedLabel?.text = "Created on : \(room.date)"
               cell.roomImage.image = UIImage(named:"model_img")
               return cell
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
        let roomToDelete = rooms[index]
        
        let alert = UIAlertController(
            title: "Delete Room",
            message: "Are you sure you want to delete \(roomToDelete.name)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Remove room from the RoomDataProvider
            RoomDataProvider.shared.removeRoom(from: RoomCategoryType(rawValue: roomToDelete.category) ?? .bathroom, byId: roomToDelete.id)
            
            // Also remove from the local rooms array used for collection view display
            self.rooms.remove(at: index)
            self.collectionView.reloadData()
        }))
        
        present(alert, animated: true, completion: nil)
    }


        }
