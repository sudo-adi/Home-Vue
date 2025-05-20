//import UIKit
//
//class SignUpViewController: UIViewController {
//
//    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var continueButton: UIButton!
//    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var reEnterPasswordTextField: UITextField!
//    @IBOutlet weak var signUpView: UIView!
//    @IBOutlet weak var backNavigationItem: UINavigationItem!
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var bgImageView: UIImageView!
//    @IBOutlet weak var stackView: UIStackView!
//    
//    private var passwordRulesLabel: UILabel!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        bgImageView.applyOverlay()
//        signUpView.addCornerRadius(20)
//        signUpView.applyGlassmorphism()
//        
//        nameTextField.configureText(
//            placeholder: "Enter Your Name",
//            placeholderColor: UIColor.lightGray)
//        nameTextField.setPadding(left: 10, right: 10)
//        nameTextField.addCornerRadius()
//        
//        emailTextField.configureText(
//            placeholder: "hello@gmail.com",
//            placeholderColor: UIColor.lightGray)
//        emailTextField.setPadding(left: 10, right: 10)
//        emailTextField.addCornerRadius()
//        passwordTextField.configureText(
//            placeholder: "Enter Password",
//            placeholderColor: UIColor.lightGray)
//        passwordTextField.setPadding(left: 10, right: 10)
//        passwordTextField.addCornerRadius()
//        
//        reEnterPasswordTextField.configureText(
//            placeholder: "Re-enter Password",
//            placeholderColor: UIColor.lightGray)
//        reEnterPasswordTextField.setPadding(left: 10, right: 10)
//        reEnterPasswordTextField.addCornerRadius()
//        
//        backNavigationItem.titleView?.tintColor = UIColor.white
//        continueButton.addCornerRadius()
//        
//        passwordRulesLabel = setupPasswordRulesLabel(in: stackView, below: passwordTextField)
//                
//        // Add text field editing changed action
//        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
//       
//    }
//
//    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
//        let isValid = validatePassword(textField.text, rulesLabel: passwordRulesLabel)
//        
//        UIView.animate(withDuration: 0.25) {
//            if isValid {
//                // When password is valid, hide the rules label and use normal spacing
//                self.passwordRulesLabel.isHidden = true
//                // Adjust spacing between password field and re-enter password field
//                if let stackView = self.passwordTextField.superview as? UIStackView {
//                    stackView.setCustomSpacing(20, after: self.passwordTextField)
//                }
//            } else {
//                // When password is invalid, show the rules label and increase spacing
//                self.passwordRulesLabel.isHidden = false
//                // Increase spacing to accommodate the rules label
//                if let stackView = self.passwordTextField.superview as? UIStackView {
//                    stackView.setCustomSpacing(40, after: self.passwordTextField)
//                }
//            }
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    @IBAction func continueButtonTapped(_ sender: Any)  {
//            // Email Sign-In Validation
//            guard let password = passwordTextField.text, !password.isEmpty,
//                  let reEnterPassword = reEnterPasswordTextField.text, !reEnterPassword.isEmpty else {
//                showAlert(on: self, message: "Please fill in both password fields.")
//                return
//            }
//
//            guard password == reEnterPassword else {
//                showAlert(on: self, message: "Passwords do not match.")
//                return
//            }
//
//            // Proceed if passwords are valid
////            handleEmailLogin(from: self, email: emailTextField.text, password: password)
//        handleEmailSignUp(from: self, email: emailTextField.text, password: password, name: name)
//    }
//    
//    
//    @IBAction func loginButtonTapped(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
//}
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var backNavigationItem: UINavigationItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    private var passwordRulesLabel: UILabel!
    private let authManager = AuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgImageView.applyOverlay()
        signUpView.addCornerRadius(20)
        signUpView.applyGlassmorphism()
        
        nameTextField.delegate=self
        nameTextField.configureText(
            placeholder: "Enter Your Name",
            placeholderColor: UIColor.lightGray)
        nameTextField.setPadding(left: 10, right: 10)
        nameTextField.addCornerRadius()
        
        emailTextField.delegate=self
        emailTextField.configureText(
            placeholder: "hello@gmail.com",
            placeholderColor: UIColor.lightGray)
        emailTextField.setPadding(left: 10, right: 10)
        emailTextField.addCornerRadius()
        
        passwordTextField.delegate=self
        passwordTextField.configureText(
            placeholder: "Enter Password",
            placeholderColor: UIColor.lightGray)
        passwordTextField.setPadding(left: 10, right: 10)
        passwordTextField.addCornerRadius()
        
        reEnterPasswordTextField.delegate=self
        reEnterPasswordTextField.configureText(
            placeholder: "Re-enter Password",
            placeholderColor: UIColor.lightGray)
        reEnterPasswordTextField.setPadding(left: 10, right: 10)
        reEnterPasswordTextField.addCornerRadius()
        
        backNavigationItem.titleView?.tintColor = UIColor.white
        continueButton.addCornerRadius()
        
        passwordRulesLabel = setupPasswordRulesLabel(in: stackView, below: passwordTextField)
                
        // Add text field editing changed action
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
    }
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        let isValid = validatePassword(textField.text, rulesLabel: passwordRulesLabel)
        
        UIView.animate(withDuration: 0.25) {
            if isValid {
                // When password is valid, hide the rules label and use normal spacing
                self.passwordRulesLabel.isHidden = true
                // Adjust spacing between password field and re-enter password field
                if let stackView = self.passwordTextField.superview as? UIStackView {
                    stackView.setCustomSpacing(20, after: self.passwordTextField)
                }
            } else {
                // When password is invalid, show the rules label and increase spacing
                self.passwordRulesLabel.isHidden = false
                // Increase spacing to accommodate the rules label
                if let stackView = self.passwordTextField.superview as? UIStackView {
                    stackView.setCustomSpacing(40, after: self.passwordTextField)
                }
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        // Email Sign-Up Validation
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(on: self, message: "Please enter your name.")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(on: self, message: "Please enter your email address.")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty,
              let reEnterPassword = reEnterPasswordTextField.text, !reEnterPassword.isEmpty else {
            showAlert(on: self, message: "Please fill in both password fields.")
            return
        }

        guard password == reEnterPassword else {
            showAlert(on: self, message: "Passwords do not match.")
            return
        }

        // Proceed with signup using handleEmailSignUp
        handleEmailSignUp(from: self, email: email, password: password, name: name)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
