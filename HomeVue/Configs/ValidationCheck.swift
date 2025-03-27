
import Foundation
import UIKit

func handleEmailLogin(from viewController: UIViewController, email: String?, password: String?) {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

    guard let email = email, !email.isEmpty, emailPredicate.evaluate(with: email) else {
        showAlert(on: viewController, message: "Please enter a valid email address.")
        return
    }
    
    guard let password = password, !password.isEmpty else {
        showAlert(on: viewController, message: "Please enter your password.")
        return
    }
        // ✅ Default navigation for other cases (e.g., Login)
        let tabBarController = CustomTabBarController()
        navigateToViewController(from: viewController, destinationVC: tabBarController)
}


// Function to show an alert
func showAlert(on viewController: UIViewController, title: String = "Error", message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}

func navigateToViewController(from viewController: UIViewController, destinationVC: UIViewController, useNavigationController: Bool = false) {
    if useNavigationController, let navController = viewController.navigationController {
        navController.pushViewController(destinationVC, animated: true)
    } else {
        destinationVC.modalPresentationStyle = .fullScreen
        viewController.present(destinationVC, animated: true, completion: nil)
    }
}

