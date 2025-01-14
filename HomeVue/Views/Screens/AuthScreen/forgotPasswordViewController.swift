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
