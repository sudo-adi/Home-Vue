//
//  PracViewController.swift
//  Auth
//
//  Created by student-2 on 13/12/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    private var passwordRulesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        loginView.addCornerRadius(20)
        loginView.layer.borderColor = UIColor.black.cgColor
        loginView.layer.borderWidth = 0.5
        
      
        emailTextField.configureText(
        placeholder: "hello@gmail.com",
        placeholderColor: UIColor.lightGray)
        emailTextField.setPadding(left: 10, right: 10)
        emailTextField.addCornerRadius()
        
        passwordTextField.configureText(
        placeholder: "Password",
        placeholderColor: UIColor.lightGray)
        passwordTextField.setPadding(left: 10, right: 10)
        passwordTextField.addCornerRadius()
        
        continueButton.addCornerRadius()
        
        passwordRulesLabel = setupPasswordRulesLabel(in: view, below: passwordTextField, aboveButton: continueButton)
                
        // Add text field editing changed action
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
    }
    
    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        let isValid = validatePassword(textField.text, rulesLabel: passwordRulesLabel)
        
        UIView.animate(withDuration: 0.25) {
            if isValid {
                self.stackView.setCustomSpacing(20, after: self.passwordTextField) // Normal spacing
            } else {
                self.stackView.setCustomSpacing(24, after: self.passwordRulesLabel) // Increase spacing
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
            // Email login validation & navigation
            handleEmailLogin(from: self, email: emailTextField.text, password: passwordTextField.text)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

}
