
import Foundation
import UIKit

// Password validation regex
private let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"

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
    
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    guard passwordPredicate.evaluate(with: password) else {
        showAlert(on: viewController, message: "Password must contain at least 8 characters with both letters and numbers.")
        return
    }

    // Navigation logic
    if viewController is SignUpViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let verifyViewController = storyboard.instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController {
            navigateToViewController(from: viewController, destinationVC: verifyViewController)
        } else {
            showAlert(on: viewController, message: "Unable to load verification screen. Please try again.")
        }
    } else {
        let tabBarController = CustomTabBarController()
        navigateToViewController(from: viewController, destinationVC: tabBarController)
    }
}

func setupPasswordRulesLabel(in view: UIView, below textField: UITextField, aboveButton button: UIButton) -> UILabel {
    let rulesLabel = UILabel()
    rulesLabel.text = "Password must contain at least 8 characters with both letters and numbers"
    rulesLabel.textColor = .red
    rulesLabel.font = .systemFont(ofSize: 12)
    rulesLabel.numberOfLines = 0
    rulesLabel.translatesAutoresizingMaskIntoConstraints = false
    rulesLabel.isHidden = true
    
    view.addSubview(rulesLabel)
    
    NSLayoutConstraint.activate([
        rulesLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
        rulesLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
        rulesLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
        rulesLabel.bottomAnchor.constraint(lessThanOrEqualTo: button.topAnchor, constant: -8)
    ])
    
    return rulesLabel
}

func validatePassword(_ password: String?, rulesLabel: UILabel) -> Bool  {
    guard let password = password else {
        rulesLabel.isHidden = false
        return false
    }
    
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    let isValid = passwordPredicate.evaluate(with: password)
    rulesLabel.isHidden = isValid
    
    return isValid
}

// Helper functions
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
