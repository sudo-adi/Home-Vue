//import Foundation
//import UIKit
//
//extension UIColor {
//    static let gradientStartColor = UIColor(red: 0x30/255.0, green: 0x2A/255.0, blue: 0x29/255.0, alpha: 1.0) // Hex #302A29
//    static let gradientEndColor = UIColor(red: 0x63/255.0, green: 0x56/255.0, blue: 0x55/255.0, alpha: 1.0)   // Hex #635655
//    static let solidBackgroundColor = UIColor(red: 0xD9/255.0, green: 0xD9/255.0, blue: 0xD9/255.0, alpha: 1.0) // Hex #D9D9D9
//}
//
//extension UIView {
//    /// - Parameter radius: The corner radius value. If not specified, the view will use half of its height to create a circular shape.
//    func addCornerRadius(_ radius: CGFloat? = nil) {
//        self.layer.cornerRadius = radius ?? self.frame.height / 2
//        self.layer.masksToBounds = true
//    }
//    
//    func applyGradientBackground(startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bounds
//        gradientLayer.colors = [UIColor.gradientStartColor.cgColor, UIColor.gradientEndColor.cgColor]
//        gradientLayer.startPoint = startPoint
//        gradientLayer.endPoint = endPoint
//
//        self.layer.insertSublayer(gradientLayer, at: 0)
//    }
//    
//}
//extension UITextField {
//    func removeCursor() {
//        self.tintColor = .clear // Makes the cursor invisible
//    }
//
//    func setPadding(left: CGFloat, right: CGFloat = 0) {
//        // Add padding to the left
//        if left > 0 {
//            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: 1))
//            self.leftView = leftPaddingView
//            self.leftViewMode = .always
//        }
//        
//        // Add padding to the right
//        if right > 0 {
//            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: 1))
//            self.rightView = rightPaddingView
//            self.rightViewMode = .always
//        }
//    }
//    
//    
//    func configureText(placeholder: String, placeholderColor: UIColor = .lightGray){
//        // Set placeholder with attributes
//        self.attributedPlaceholder = NSAttributedString(
//            string: placeholder,
//            attributes: [.foregroundColor: placeholderColor]
//        )
//    }
//}
//
//   
//extension UISegmentedControl{
//    func setCustomAppearance(selectedBackgroundColor: UIColor = .white,
//                                 selectedTextColor: UIColor = .black,
//                                 normalTextColor: UIColor = .white) {
//            self.setTitleTextAttributes([.backgroundColor: selectedBackgroundColor,
//                                         .foregroundColor: selectedTextColor], for: .selected)
//            self.setTitleTextAttributes([.foregroundColor: normalTextColor], for: .normal)
//        }
//    
//    func updateUI(emailTextField: UITextField, passwordTextField: UITextField, phoneTextField: UITextField, parentView: UIView) {
//            switch self.selectedSegmentIndex {
//            case 0:
//                emailTextField.isHidden = false
//                passwordTextField.isHidden = false
//                phoneTextField.isHidden = true
//            case 1:
//                emailTextField.isHidden = true
//                passwordTextField.isHidden = true
//                phoneTextField.isHidden = false
//            default:
//                break
//            }
//            UIView.animate(withDuration: 0.3) {
//                parentView.layoutIfNeeded()
//            }
//        }
//    
//}
//
//extension UIViewController {
//    func navigateToViewController(identifier: String) {
//        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
//            navigationController?.pushViewController(viewController, animated: true)
//        }
//    }
//
//    func showAlert(title: String = "Error", message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//    
//    func handleEmailLogin(email: String?, password: String?) {
//            guard let email = email, !email.isEmpty,
//                  let password = password, !password.isEmpty else {
//                showAlert(message: "Please fill in both email and password.")
//                return
//            }
//            
//            navigateToViewController(identifier: "MainViewController")
//        }
//
//        func handlePhoneLogin(phone: String?) {
//            guard let phone = phone, !phone.isEmpty else {
//                showAlert(message: "Please enter your phone number.")
//                return
//            }
//            navigateToViewController(identifier: "VerifyViewController")
//        }
//}
