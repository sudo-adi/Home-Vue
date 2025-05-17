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

}
