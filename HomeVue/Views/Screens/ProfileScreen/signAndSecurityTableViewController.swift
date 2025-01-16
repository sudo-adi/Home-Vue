//
//  signAndSecurityTableViewController.swift
//  Home Vue
//
//  Created by student-2 on 10/12/24.
//

import UIKit
class signAndSecurityTableViewController: UITableViewController {
    
    @IBOutlet weak var EditEmailOrPhoneButton: UIButton!
    @IBOutlet weak var EmailLAbel: UILabel!
    
    @IBOutlet weak var MobileNumberLabel: UILabel!
    @IBOutlet weak var ChangePassword: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        if let navigationBar = self.navigationController?.navigationBar {
            
            navigationBar.titleTextAttributes = [ .foregroundColor: UIColor.gradientEndColor]
            navigationBar.tintColor = UIColor.gradientEndColor
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
        if let navigationBar = self.navigationController?.navigationBar {
            // Revert to the default appearance
            navigationBar.titleTextAttributes = nil
            navigationBar.tintColor = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .solidBackgroundColor
        EditEmailOrPhoneButton.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        ChangePassword.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        MobileNumberLabel.text = User1.mobile
        EmailLAbel.text = User1.UserEmail
        
        
        
        applyGradientBackground(to: self.view,
                                    startColor: .gradientStartColor,
                                    endColor: .gradientEndColor)
        
       
    }
    
    
    func applyGradientBackground(to view: UIView, startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top-left
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)   // Bottom-right
        
        // Add the gradient layer to the view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            if let headerView = view as? UITableViewHeaderFooterView {
                headerView.textLabel?.textColor = .white
                headerView.textLabel?.font = UIFont.headerFont()
            }
        }
    
    @objc func handleButtonTap(_ sender: UIButton) {
            let alertController = UIAlertController(title: "Verify Password", message: "Enter your current password", preferredStyle: .alert)
            
            alertController.addTextField { textField in
                textField.placeholder = "Current Password"
                textField.isSecureTextEntry = true
            }
        let UserPassword = User1.UserPassword
 
            let verifyAction = UIAlertAction(title: "Verify", style: .default) { _ in
                if let password = alertController.textFields?.first?.text, password == UserPassword {
                    if sender == self.EditEmailOrPhoneButton {
                        self.performSegue(withIdentifier: "EditEmailSegue", sender: nil)
                    } else if sender == self.ChangePassword {
                        self.performSegue(withIdentifier: "ChangePasswordSegue", sender: nil)
                    }
                } else {
                    self.showErrorMessage()
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(verifyAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        func showErrorMessage() {
            let errorAlert = UIAlertController(title: "Error", message: "Incorrect password. Please try again.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }

    @IBAction func unwindToSignIn(_ segue: UIStoryboardSegue) {
        // Perform any cleanup or setup after unwinding here
        print("Unwind to Sign In triggered")
    }
}
