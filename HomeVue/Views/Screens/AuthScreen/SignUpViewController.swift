//
//  SignUpViewController.swift
//  Auth
//
//  Created by student-2 on 04/12/24.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var backNavigationItem: UINavigationItem!
    @IBOutlet weak var emailTextField: UITextField!
    
    private var passwordRulesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpView.layer.borderColor = UIColor.black.cgColor
        signUpView.layer.borderWidth = 0.5
        signUpView.addCornerRadius(20)
        
        emailTextField.configureText(
            placeholder: "hello@gmail.com",
            placeholderColor: UIColor.lightGray)
        emailTextField.setPadding(left: 10, right: 10)
        emailTextField.addCornerRadius(17)
        passwordTextField.configureText(
            placeholder: "Enter Password",
            placeholderColor: UIColor.lightGray)
        passwordTextField.setPadding(left: 10, right: 10)
        passwordTextField.addCornerRadius()
        
        reEnterPasswordTextField.configureText(
            placeholder: "Re-enter Password",
            placeholderColor: UIColor.lightGray)
        reEnterPasswordTextField.setPadding(left: 10, right: 10)
        reEnterPasswordTextField.addCornerRadius()
        
        backNavigationItem.titleView?.tintColor = UIColor.white
        continueButton.addCornerRadius()
        
        passwordRulesLabel = setupPasswordRulesLabel(in: view, below: passwordTextField, aboveButton: continueButton)
                
        // Add text field editing changed action
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
       
    }
    
    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        validatePassword(textField.text, rulesLabel: passwordRulesLabel)
    }

    @IBAction func continueButtonTapped(_ sender: Any)  {
            // Email Sign-In Validation
            guard let password = passwordTextField.text, !password.isEmpty,
                  let reEnterPassword = reEnterPasswordTextField.text, !reEnterPassword.isEmpty else {
                showAlert(on: self, message: "Please fill in both password fields.")
                return
            }

            guard password == reEnterPassword else {
                showAlert(on: self, message: "Passwords do not match.")
                return
            }

            // Proceed if passwords are valid
            handleEmailLogin(from: self, email: emailTextField.text, password: password)

    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
