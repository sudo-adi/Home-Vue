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

            override func viewDidLoad() {
                super.viewDidLoad()
                collectionView.collectionViewLayout = createLayout()
                setupNavigationBarAppearance()
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
                    collectionView.addGestureRecognizer(longPressGesture)
                self.title = roomCategory.category.rawValue
                rooms = RoomDataProvider.shared.getRooms(for: roomCategory.category)
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
               cell.nameLabel.text = room.details.name
               cell.dateCreatedLabel?.text = "Created on : \(room.details.createdDate)"
               cell.roomImage.image = UIImage(named:"model_img")
               return cell
           }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        showCustomAlert()
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
            message: "Are you sure you want to delete \(roomToDelete.details.name)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Remove room from the RoomDataProvider
            RoomDataProvider.shared.removeRoom(from: RoomCategoryType(rawValue: roomToDelete.category.rawValue) ?? .bathroom, byId: roomToDelete.details.id)
            
            // Also remove from the local rooms array used for collection view display
            self.rooms.remove(at: index)
            self.collectionView.reloadData()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    private func showCustomAlert() {
        // Create a custom alert view
        let alertView = UIView()
        alertView.backgroundColor = UIColor(red: 156/255, green: 138/255, blue: 124/255, alpha: 0.8) // 9C8A7C with 80% opacity
        alertView.layer.cornerRadius = 12
        alertView.translatesAutoresizingMaskIntoConstraints = false

        // Add Title Label
        let titleLabel = UILabel()
        titleLabel.text = "Scan Your Room"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold) // Increased size and lighter weight
        titleLabel.textColor = UIColor(red: 255/255, green: 247/255, blue: 231/255, alpha: 0.9) // FFF7E7 with 90% opacity
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)

        // Add Room Name Text Field
        let roomNameTextField = UITextField()
        roomNameTextField.placeholder = "Room Name"
        roomNameTextField.borderStyle = .roundedRect
        roomNameTextField.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 231/255, alpha: 1.0) // FFF7E7
        roomNameTextField.translatesAutoresizingMaskIntoConstraints = false

        // Center the typed text
        roomNameTextField.textAlignment = .center // This ensures typed text is centered ✅

        // Create a paragraph style to center placeholder text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        // Set the placeholder with centered text
        roomNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Room Name",
            attributes: [
                .foregroundColor: UIColor.darkGray, // Placeholder text color
                .paragraphStyle: paragraphStyle
            ]
        )
        alertView.addSubview(roomNameTextField)

        // Add Room Type Selector Button
        let roomTypeButton = UIButton(type: .system)
        roomTypeButton.setTitle("Select Room Type", for: .normal)
        roomTypeButton.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 231/255, alpha: 1.0) // FFF7E7
        roomTypeButton.layer.cornerRadius = 5
        roomTypeButton.setTitleColor(UIColor(red: 57/255, green: 50/255, blue: 49/255, alpha: 1.0), for: .normal) // 393231
        roomTypeButton.addTarget(self, action: #selector(showRoomTypePicker), for: .touchUpInside)
        roomTypeButton.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(roomTypeButton)

        // Add Cancel Button
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .clear // Transparent background
        cancelButton.layer.cornerRadius = 5
        cancelButton.setTitleColor(UIColor(red: 255/255, green: 247/255, blue: 231/255, alpha: 1.0), for: .normal) // FFF7E7
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(cancelButton)

        // Add Create Button
        let createButton = UIButton(type: .system)
        createButton.setTitle("Create", for: .normal)
        createButton.backgroundColor = .clear // Transparent background
        createButton.layer.cornerRadius = 5
        createButton.setTitleColor(UIColor(red: 255/255, green: 247/255, blue: 231/255, alpha: 1.0), for: .normal) // FFF7E7
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(createButton)

        // Add constraints for the alert view
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),

            roomNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            roomNameTextField.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            roomNameTextField.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            roomNameTextField.heightAnchor.constraint(equalToConstant: 40),

            roomTypeButton.topAnchor.constraint(equalTo: roomNameTextField.bottomAnchor, constant: 16),
            roomTypeButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            roomTypeButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            roomTypeButton.heightAnchor.constraint(equalToConstant: 40),

            cancelButton.topAnchor.constraint(equalTo: roomTypeButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),

            createButton.topAnchor.constraint(equalTo: roomTypeButton.bottomAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20),
            createButton.widthAnchor.constraint(equalToConstant: 100),
            createButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Create a container view to hold the alert view
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(alertView)

        // Add constraints for the container view
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 300)
        ])

        // Add the container view to the main view
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Animate the alert view
        alertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        alertView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            alertView.transform = .identity
            alertView.alpha = 1
        }, completion: nil)
    }

    @objc private func showRoomTypePicker() {
        let pickerAlert = UIAlertController(title: "Select Room Type", message: nil, preferredStyle: .actionSheet)

        // Set background color for the action sheet
        if let view = pickerAlert.view.subviews.first?.subviews.first {
            view.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 231/255, alpha: 1.0) // FFF7E7
            view.layer.cornerRadius = 12 // Rounded corners
            view.clipsToBounds = true
        }

        // Set title text color
        pickerAlert.setValue(
            NSAttributedString(
                string: "Select Room Type",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                    .foregroundColor: UIColor(red: 61/255, green: 48/255, blue: 47/255, alpha: 1.0) // 3D302F
                ]
            ),
            forKey: "attributedTitle"
        )

        // Set text color for all actions
        for roomType in RoomCategoryType.allCases {
            let action = UIAlertAction(title: roomType.rawValue, style: .default) { _ in
                if let alertView = self.view.subviews.last?.subviews.first as? UIView,
                   let roomTypeButton = alertView.subviews.compactMap({ $0 as? UIButton }).first(where: { $0.titleLabel?.text == "Select Room Type" }) {
                    roomTypeButton.setTitle(roomType.rawValue, for: .normal)
                }
            }
            action.setValue(UIColor(red: 57/255, green: 50/255, blue: 49/255, alpha: 1.0), forKey: "titleTextColor") // 393231
            pickerAlert.addAction(action)
        }

        // Add Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(red: 57/255, green: 50/255, blue: 49/255, alpha: 1.0), forKey: "titleTextColor") // 393231
        pickerAlert.addAction(cancelAction)

        // Present the action sheet
        present(pickerAlert, animated: true, completion: nil)
    }

    @objc private func cancelButtonTapped() {
        // Dismiss the custom alert with animation
        if let containerView = view.subviews.last {
            UIView.animate(withDuration: 0.3, animations: {
                containerView.alpha = 0
            }, completion: { _ in
                containerView.removeFromSuperview()
            })
        }
    }

    @objc private func createButtonTapped() {
        // Dismiss the custom alert with animation
        if let containerView = view.subviews.last {
            UIView.animate(withDuration: 0.3, animations: {
                containerView.alpha = 0
            }, completion: { _ in
                containerView.removeFromSuperview()
            })
        }

        // Open CaptureViewController
//        let captureVC = CaptureViewController()
//        captureVC.modalPresentationStyle = .fullScreen
//        self.present(captureVC, animated: true, completion: nil)
    }

        }
