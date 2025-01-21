import UIKit

class CustomTabBarController: UITabBarController {

    private let customTabBarBackground = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
        self.delegate = self // Set the delegate to handle tab selection
    }

    private func setupTabBar() {
        // Create and configure the custom background view
        customTabBarBackground.backgroundColor = .white
        customTabBarBackground.layer.cornerRadius = 35
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
//MARK:
    private func setupViewControllers() {
        // First View Controller (Home)
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "Home", // Empty string to ensure no label is shown
            image: UIImage(systemName: "house"), // Outlined icon
            selectedImage: UIImage(systemName: "house.fill") // Filled icon for active state
        )

        // Second View Controller (Camera)
        let cameraVC = UIViewController() // Placeholder, not used directly
        cameraVC.tabBarItem = UITabBarItem(
            title: "Scan", // Empty string to ensure no label is shown
            image: UIImage(systemName: "camera"), // Outlined icon
            selectedImage: UIImage(systemName: "camera.fill") // Filled icon for active state
        )

        // Third View Controller (Profile)
        let profileVC = LoginMainPageViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile", // Empty string to ensure no label is shown
            image: UIImage(systemName: "person"), // Outlined icon
            selectedImage: UIImage(systemName: "person.fill") // Filled icon for active state
        )

        // Set the view controllers for the tab bar
        viewControllers = [homeVC, cameraVC, profileVC]
    }

    // Show custom alert when the Camera tab is clicked
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
        let roomTypes = ["Living Room", "Bedroom", "Kitchen", "Bathroom", "Dining Room"]
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
        for roomType in roomTypes {
            let action = UIAlertAction(title: roomType, style: .default) { _ in
                if let alertView = self.view.subviews.last?.subviews.first as? UIView,
                   let roomTypeButton = alertView.subviews.compactMap({ $0 as? UIButton }).first(where: { $0.titleLabel?.text == "Select Room Type" }) {
                    roomTypeButton.setTitle(roomType, for: .normal)
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
        let captureVC = CaptureViewController()
        captureVC.modalPresentationStyle = .fullScreen
        self.present(captureVC, animated: true, completion: nil)
    }
}

// MARK: - UITabBarControllerDelegate
extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.image == UIImage(systemName: "camera") { // Camera tab
            showCustomAlert()
            return false // Prevent switching to the Camera tab
        }
        return true
    }
}
