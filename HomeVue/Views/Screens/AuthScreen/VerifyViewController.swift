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
        setupUI()
        
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
    private func setupUI() {
        verifyButton.addCornerRadius()
        resendOTPButton.addCornerRadius()
    }
    
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
    @IBAction func verifyButtonTapped(_ sender: Any) {
        let otp = getOTP()
        if otp.count == 4 {
            print("Entered OTP: \(otp)")
            
            // Instantiate the CustomTabBarController programmatically
            let tabBarController = CustomTabBarController()
            tabBarController.selectedIndex = 0 // Select the first tab (Home)
            
            // Set the CustomTabBarController as the root view controller of the window
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                // Add slide-in animation
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                
                window.layer.add(transition, forKey: kCATransition)
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
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
