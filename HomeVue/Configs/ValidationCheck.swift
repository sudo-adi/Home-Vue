
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

    // ✅ Check if coming from SignUpViewController
    if viewController is SignUpViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let verifyViewController = storyboard.instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController {
            navigateToViewController(from: viewController, destinationVC: verifyViewController)
        } else {
            showAlert(on: viewController, message: "Unable to load verification screen. Please try again.")
        }
    } else {
        // ✅ Default navigation for other cases (e.g., Login)
        let tabBarController = CustomTabBarController()
        navigateToViewController(from: viewController, destinationVC: tabBarController)
    }
}


func handlePhoneLogin(from viewController: UIViewController, phone: String?) {
    let phoneRegex = "^[0-9]{10}$" // Regular expression for exactly 10 digits
    let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)

    guard let phone = phone, phonePredicate.evaluate(with: phone) else {
        showAlert(on: viewController, message: "Please enter a valid 10-digit phone number.")
        return
    }

    // ✅ Load VerifyViewController from Storyboard
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let verifyViewController = storyboard.instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController {
        navigateToViewController(from: viewController, destinationVC: verifyViewController)
    } else {
        showAlert(on: viewController, message: "Unable to load verification screen. Please try again.")
    }
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

