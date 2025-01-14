//
//  VerifyViewController.swift
//  Auth
//
//  Created by student-2 on 19/12/24.
//

import UIKit

class VerifyViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyButton.addCornerRadius()
        resendOTPButton.addCornerRadius()
        otpTextField1.removeCursor()
        otpTextField2.removeCursor()
        otpTextField3.removeCursor()
        otpTextField4.removeCursor()
        
        
        otpTextField1.delegate = self
        otpTextField2.delegate = self
        otpTextField3.delegate = self
        otpTextField4.delegate = self
        
        otpTextField1.setPadding(left: 5, right: 5)
        otpTextField2.setPadding(left: 5, right: 5)
        otpTextField3.setPadding(left: 5, right: 5)
        otpTextField4.setPadding(left: 5, right: 5)
        
        
           // Set a default style if needed
           [otpTextField1, otpTextField2, otpTextField3, otpTextField4].forEach {
               $0?.keyboardType = .numberPad
               $0?.textAlignment = .center
           }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
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
    
    func getOTP() -> String {
        return "\(otpTextField1.text ?? "")\(otpTextField2.text ?? "")\(otpTextField3.text ?? "")\(otpTextField4.text ?? "")"
    }
    
    @IBAction func verifyButtonTapped(_ sender: Any) {
        let otp = getOTP()
        if otp.count == 4 {
           print("Entered OTP: \(otp)")
        } else {
           showAlert(message: "Please enter a 4-digit OTP.")
        }
    }
    func showAlert(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
