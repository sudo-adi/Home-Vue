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
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var backNavigationItem: UINavigationItem!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpView.layer.borderColor = UIColor.black.cgColor
        signUpView.layer.borderWidth = 0.5
        signUpView.addCornerRadius(20)
        
        configureUI()
        segmentedControl.setCustomAppearance()
        
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
      
        phoneTextField.configureText(
            placeholder: "e.g. 94567XXXXX",
            placeholderColor: UIColor.lightGray)
        phoneTextField.setPadding(left: 10, right: 10)
        phoneTextField.addCornerRadius(17)
        
       
    }
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        sender.updateUI(emailTextField: emailTextField, passwordTextField: passwordTextField, reEnterTextField: reEnterPasswordTextField, phoneTextField: phoneTextField, parentView: self.view)
    }
    func configureUI() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.updateUI(emailTextField: emailTextField, passwordTextField: passwordTextField, phoneTextField: phoneTextField, parentView: self.view)
    }
    

    @IBAction func continueButtonTapped(_ sender: Any)  {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
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

        case 1:
            // Phone Sign-In
            handlePhoneLogin(from: self, phone: phoneTextField.text)
        
        default:
            break
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
