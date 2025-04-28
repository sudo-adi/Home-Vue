//
//  forgotPasswordViewController.swift
//  Auth
//
//  Created by student-2 on 04/12/24.
//

import UIKit

class forgotPasswordViewController: UIViewController {

    @IBOutlet weak var forgotPassVIew: UIView!
    @IBOutlet weak var enterEmailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    private var passwordRulesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgotPassVIew.layer.borderColor = UIColor.black.cgColor
        forgotPassVIew.layer.borderWidth = 0.5
        forgotPassVIew.addCornerRadius(30)
        
        enterEmailTextField.configureText(
            placeholder: "Enter your Email",
            placeholderColor:  UIColor.lightGray)
        enterEmailTextField.setPadding(left: 10, right: 10)
        enterEmailTextField.addCornerRadius()
        
        newPasswordTextField.configureText(
            placeholder: "Enter your New Password",
            placeholderColor:  UIColor.lightGray)
        newPasswordTextField.setPadding(left: 10, right: 10)
        newPasswordTextField.addCornerRadius()
        
        confirmPasswordTextField.configureText(
            placeholder: "Confirm your New Password",
            placeholderColor:  UIColor.lightGray)
        confirmPasswordTextField.setPadding(left: 10, right: 10)
        confirmPasswordTextField.addCornerRadius()
        
        continueButton.addCornerRadius()
        
        passwordRulesLabel = setupPasswordRulesLabel(in: view, below: newPasswordTextField, aboveButton: continueButton)
                
        // Add text field editing changed action
        newPasswordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = .clear
//        appearance.shadowColor = .clear
//
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//
//        navigationItem.title = "" // no title
////        navigationItem.backButtonTitle = "" // cleaner back button
//        navigationController?.navigationBar.tintColor = .white // or white depending on your UI
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithDefaultBackground() // Reset to system default
//
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//    }

    
    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        let isValid = validatePassword(textField.text, rulesLabel: passwordRulesLabel)
        
        UIView.animate(withDuration: 0.25) {
            if isValid {
                self.stackView.setCustomSpacing(20, after: self.newPasswordTextField) // Normal spacing
            } else {
                self.stackView.setCustomSpacing(24, after: self.passwordRulesLabel) // Increase spacing
            }
            self.view.layoutIfNeeded()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func continueButtonTapped(_ sender: Any) {
        let email = enterEmailTextField.text
        let newPassword = newPasswordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        
        // Validate email first using handleEmailLogin logic
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        guard let email = email, !email.isEmpty, emailPredicate.evaluate(with: email) else {
            showAlert(on: self, message: "Please enter a valid email address.")
            return
        }
        
        // Ensure both password fields are filled
        guard let newPassword = newPassword, !newPassword.isEmpty,
              let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            showAlert(on: self, message: "Please fill in both password fields.")
            return
        }

        // Check if passwords match
        guard newPassword == confirmPassword else {
            showAlert(on: self, message: "Passwords do not match.")
            return
        }

            showAlert(on: self, message: "Unable to load verification screen. Please try again.")
    }
}
