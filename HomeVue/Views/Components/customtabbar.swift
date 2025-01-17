import UIKit

class CustomTabBarController: UITabBarController {

    private let customTabBarBackground = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
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

        let fourthVC = HomeViewController()
        fourthVC.tabBarItem = UITabBarItem(title: "Fourth", image: UIImage(systemName: "house"), tag: 3)

        viewControllers = [fourthVC]
    }
}
