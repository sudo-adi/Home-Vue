//
//  VerifyViewController.swift
//  Auth
//
//  Created by student-2 on 19/12/24.
//

import UIKit

class VerifyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
//        setupUI()
        
        // Set delegates for OTP text fields
        [otpTextField1, otpTextField2, otpTextField3, otpTextField4].forEach {
            $0?.delegate = self
            $0?.keyboardType = .numberPad
            $0?.textAlignment = .center
            $0?.setPadding(left: 5, right: 5)
            $0?.removeCursor()
        }
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UI Setup
//    private func setupUI() {
//        if let verifyBtn = verifyButton {
//            verifyBtn.addCornerRadius()
//        }
//        
//        if let resendBtn = resendOTPButton {
//            resendBtn.addCornerRadius()
//        }
//    }
    
    // MARK: - Dismiss Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ensure only one character is entered
        guard string.count <= 1 else { return false }
        
        // If a character is entered, move to the next field
        if !string.isEmpty {
            let nextTag = textField.tag + 1
            if let nextResponder = self.view.viewWithTag(nextTag) as? UITextField {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder() // Close keyboard if it's the last field
            }
            
            textField.text = string // Set the entered character
            return false // Prevent adding the character twice
        } else {
            // Handle backspace: move to the previous field
            let previousTag = textField.tag - 1
            if let previousResponder = self.view.viewWithTag(previousTag) as? UITextField {
                previousResponder.becomeFirstResponder()
            }
            textField.text = "" // Clear the current text field
            return false
        }
    }
    
    // MARK: - Get OTP
    func getOTP() -> String {
        return "\(otpTextField1.text ?? "")\(otpTextField2.text ?? "")\(otpTextField3.text ?? "")\(otpTextField4.text ?? "")"
    }
    
    // MARK: - Verify Button Action
    @IBAction func verifyButtonTapped(_ sender: Any)  {
        let otp = getOTP()
        
        if otp.count == 4 {
            print("Entered OTP: \(otp)")
            
            // ✅ Check if coming from SignUpViewController
            if let navigationController = self.navigationController,
               let previousVC = navigationController.viewControllers.dropLast().last,
               previousVC is SignUpViewController {
                
                // Unwind navigation stack two pages back to reach LoginViewController
                if let viewControllers = navigationController.viewControllers as? [UIViewController] {
                    // Find the LoginViewController in the navigation stack
                    for controller in viewControllers {
                        if controller is LoginViewController {
                            // Pop to LoginViewController
                            navigationController.popToViewController(controller, animated: true)
                            return
                        }
                    }
                    
                    // If LoginViewController is not in the stack, instantiate and replace stack
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                        navigationController.setViewControllers([loginViewController], animated: true)
                    } else {
                        showAlert(message: "Unable to load Login screen. Please try again.")
                    }
                }
                
            } else {
                // ✅ Default navigation for other cases (e.g., login OTP verification)
                let tabBarController = CustomTabBarController()
                UIApplication.shared.windows.first?.rootViewController = tabBarController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
            
        } else {
            showAlert(message: "Please enter a 4-digit OTP.")
        }
    }
    // MARK: - Show Alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
