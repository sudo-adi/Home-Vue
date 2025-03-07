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
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        configureUI()
        
        loginView.addCornerRadius(20)
        loginView.layer.borderColor = UIColor.black.cgColor
        loginView.layer.borderWidth = 0.5
        
        segmentedControl.setCustomAppearance()
      
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
        
        phoneTextField.configureText(
        placeholder: "e.g. 94567XXXXX",
        placeholderColor: UIColor.lightGray)
        phoneTextField.setPadding(left: 10, right: 10)
        phoneTextField.addCornerRadius(17)
        
        continueButton.addCornerRadius()
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
            sender.updateUI(
            emailTextField: emailTextField,
            passwordTextField: passwordTextField,
            phoneTextField: phoneTextField,
            parentView: self.view)
    }
    
    func configureUI() {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.updateUI(
            emailTextField: emailTextField,
            passwordTextField: passwordTextField,
            phoneTextField: phoneTextField,
            parentView: self.view)
        }
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // Email login validation & navigation
            handleEmailLogin(from: self, email: emailTextField.text, password: passwordTextField.text)
            
        case 1:
            // Phone login validation & navigation
            handlePhoneLogin(from: self, phone: phoneTextField.text)
            
        default:
            break
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
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    func navigateToVerifyViewController(email: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let verifyVC = storyboard.instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController {
            //verifyVC.email = email  // Pass email if needed
            navigationController?.pushViewController(verifyVC, animated: true)
        }
    }
    

}
