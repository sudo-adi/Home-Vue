//
//  SignInWithEmailPhoneViewController.swift
//  Auth
//
//  Created by student-2 on 03/12/24.
//

import UIKit

class SignInWithEmailPhoneViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var huiSegmentedControl: UISegmentedControl!
    @IBOutlet weak var loginView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        huiSegmentedControl.layer.cornerRadius = 25
        huiSegmentedControl.clipsToBounds = true
        huiSegmentedControl.setTitleTextAttributes([.backgroundColor:UIColor.white], for: .selected)
        huiSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        huiSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.configureText(placeholder: "hello@gmail.com", placeholderColor: UIColor.lightGray)
        emailTextField.setPadding(left: 10, right: 10)
        
       
        passwordTextField.configureText(placeholder: "Password", placeholderColor: UIColor.lightGray)
        passwordTextField.setPadding(left: 10, right: 10)
        
        loginView.layer.borderColor = UIColor.black.cgColor
        loginView.layer.borderWidth = 0.5
        loginView.addCornerRadius(30)
        
        emailTextField.addCornerRadius()
        passwordTextField.addCornerRadius()
        continueButton.addCornerRadius()
        
       
        
        
    }

}
