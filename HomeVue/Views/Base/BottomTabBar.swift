import UIKit


// First View Controller
class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        let label = UILabel()
        label.text = "First View"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


// Second View Controller
class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        let label = UILabel()
        label.text = "Second View"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


// Third View Controller
class ThirdViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
        let label = UILabel()
        label.text = "Third View"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


// Custom Tab Bar Controller
class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create view controllers
        let firstVC = FirstViewController()
        firstVC.tabBarItem = UITabBarItem(
            title: "First",
            image: UIImage(systemName: "1.circle"),
            tag: 0
        )
        
        let secondVC = SecondViewController()
        secondVC.tabBarItem = UITabBarItem(
            title: "Second",
            image: UIImage(systemName: "2.circle"),
            tag: 1
        )
        
        let thirdVC = ThirdViewController()
        thirdVC.tabBarItem = UITabBarItem(
            title: "Third",
            image: UIImage(systemName: "3.circle"),
            tag: 2
        )
        
        // Set view controllers
        viewControllers = [
            UINavigationController(rootViewController: firstVC),
            UINavigationController(rootViewController: secondVC),
            UINavigationController(rootViewController: thirdVC)
        ]
        
        // Customize tab bar appearance
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .systemBlue // Selected tab color
        tabBar.unselectedItemTintColor = .gray
    }
}
