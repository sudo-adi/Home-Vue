import UIKit
import SwiftUI
class CustomTabBarController: UITabBarController {
    private var selectedRoomName: String?
    private var selectedRoomType: RoomCategoryType?
    
    func hideTabBar() {
        UIView.animate(withDuration: 0.0) {
            self.tabBar.alpha = 0
            self.customTabBarBackground.alpha = 0
        }
    }

    // Method to show the tab bar and its custom background
    func showTabBar() {
        UIView.animate(withDuration: 0.0) {
            self.tabBar.alpha = 1
            self.customTabBarBackground.alpha = 1
        }
    }

    private let customTabBarBackground = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
//        self.delegate = self // Set the delegate to handle tab selection
    }

    private func setupTabBar() {
        // Create and configure the custom background view
        customTabBarBackground.backgroundColor = .white
        customTabBarBackground.layer.cornerRadius = 25
        customTabBarBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Add shadow
        customTabBarBackground.layer.shadowColor = UIColor.black.cgColor
        customTabBarBackground.layer.shadowOpacity = 0.1
        customTabBarBackground.layer.shadowOffset = CGSize(width: 0, height: -3)
        customTabBarBackground.layer.shadowRadius = 10
        
        // Important: Add the custom background to the view, not the tab bar
        view.addSubview(customTabBarBackground)
        view.bringSubviewToFront(tabBar)
        
        // Configure tab bar appearance
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .clear
        tabBar.tintColor = UIColor(red: 57/255, green: 50/255, blue: 49/255, alpha: 1.0) // #393231
        tabBar.unselectedItemTintColor = UIColor(red: 57/255, green: 50/255, blue: 49/255, alpha: 1.0) // #393231
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjust the frame to cover the entire tab bar area
        customTabBarBackground.frame = CGRect(
            x: 0, // Start from the left edge of the screen
            y: view.bounds.height - tabBar.frame.height - 20, // Position it correctly
            width: view.bounds.width,
            height: tabBar.frame.height + 20 // Include extra height for rounded corners
        )
    }

    private func setupViewControllers() {
        // First View Controller (Home)
        let homeVC = HomeViewController()
        let nvc = UINavigationController(rootViewController: homeVC)
    
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let experienceVC = UIHostingController(rootView: ExperienceSelectionView()
                    .environmentObject(PlacementSettings())
                    .environmentObject(SessionSettings()))
                experienceVC.tabBarItem = UITabBarItem(
                    title: "AR",
                    image: UIImage(systemName: "camera"),
                    selectedImage: UIImage(systemName: "camera.fill"))

        // Third View Controller (Profile)
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)

        // Instantiate the navigation controller from the storyboard
        if let profileNavigationController = storyboard.instantiateViewController(withIdentifier: "profileNavigationController") as? UINavigationController,
           let profileVC = profileNavigationController.viewControllers.first as? LoginMainPageViewController {
           
            // Configure the tab bar item for the profile navigation controller
            profileNavigationController.tabBarItem = UITabBarItem(
                title: "Profile",
                image: UIImage(systemName: "person"), // Outlined icon
                selectedImage: UIImage(systemName: "person.fill") // Filled icon for active state
            )
            
            // Assuming `homeVC` and `cameraVC` are similarly instantiated or created
            viewControllers = [nvc, experienceVC, profileNavigationController]
        } else {
            print("Error: Could not instantiate profileNavigationController or LoginMainPageViewController")
        }
    }

    // Show custom alert when the Camera tab is clicked
    func showCustomAlert(preselectedCategory: RoomCategoryType? = nil) {
        // Create a custom alert view
        let alertView = UIView()
        alertView.backgroundColor = UIColor(red: 156/255, green: 138/255, blue: 124/255, alpha: 0.8) // 9C8A7C with 80% opacity
        alertView.layer.cornerRadius = 12
        alertView.translatesAutoresizingMaskIntoConstraints = false

        // Add Title Label
        let titleLabel = UILabel()
        titleLabel.text = "Scan Your Room"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold) // Increased size and lighter weight
        titleLabel.textColor = UIColor(red: 255/255, green: 247/255, blue: 231/255, alpha: 1.0) // FFF7E7 with 90% opacity
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

    @objc func showRoomTypePicker() {
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
                   let roomTypeButton = alertView.subviews.compactMap({ $0 as? UIButton }).first{
                    roomTypeButton.setTitle(roomType.rawValue, for: .normal)
                    self.selectedRoomType = roomType
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
        if let alertView = view.subviews.last?.subviews.first as? UIView,
                   let roomNameTextField = alertView.subviews.compactMap({ $0 as? UITextField }).first,
                   let roomName = roomNameTextField.text, !roomName.isEmpty,
                   let roomType = selectedRoomType {
                    
                    // Store the values
                    self.selectedRoomName = roomName
                    
                    // Dismiss the custom alert with animation
                    if let containerView = view.subviews.last {
                        UIView.animate(withDuration: 0.3, animations: {
                            containerView.alpha = 0
                        }, completion: { _ in
                            containerView.removeFromSuperview()
                            
                            // Present RoomScanView using UIHostingController
                            let roomScanVC = UIHostingController(rootView: RoomScanView())
                            roomScanVC.modalPresentationStyle = .fullScreen
                            self.present(roomScanVC, animated: true, completion: nil)
                        })
                    }
        } else {
            // Show error alert if room name is empty or room type is not selected
            let alert = UIAlertController(title: "Invalid Input",
                                        message: "Please enter a room name and select a room type.",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

}

// MARK: - UITabBarControllerDelegate
//extension CustomTabBarController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController.tabBarItem.image == UIImage(systemName: "camera") { // Camera tab
//            showCustomAlert()
//            return false // Prevent switching to the Camera tab
//        }
//        return true
//    }
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//            if viewController.tabBarItem.image == UIImage(systemName: "camera") {
//                let experienceVC = UIHostingController(rootView: ExperienceSelectionView())
//                experienceVC.modalPresentationStyle = .fullScreen
//                self.present(experienceVC, animated: true, completion: nil)
//                return false
//            }
//            return true
//        }
//}
