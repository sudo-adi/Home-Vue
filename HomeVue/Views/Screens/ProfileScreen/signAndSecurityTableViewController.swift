//
//  signAndSecurityTableViewController.swift
//  Home Vue
//
//  Created by student-2 on 10/12/24.
//

import UIKit
class signAndSecurityTableViewController: UITableViewController,EditMailAndPhoneDelegate {
    
    @IBOutlet weak var EditEmailOrPhoneButton: UIButton!
    @IBOutlet weak var EmailLAbel: UILabel!
    @IBOutlet weak var MobileNumberLabel: UILabel!
    @IBOutlet weak var ChangePassword: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Update navigation bar appearance
//            if let navigationBar = self.navigationController?.navigationBar {
//                navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gradientEndColor]
//                navigationBar.tintColor = UIColor.gradientEndColor
//            }
            
            // Fetch updated user data
            updateUserInterface()
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.hideTabBar()
        }
    }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            customizeNavigationBar()
            if let tabBarController = self.tabBarController as? CustomTabBarController {
                tabBarController.showTabBar()
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .solidBackgroundColor
            customizeNavigationBar()
            // Set up button actions
            EditEmailOrPhoneButton.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            ChangePassword.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            
            // Apply gradient background
            self.view.applyGradientBackground()
            
            // Fetch and display user data
            updateUserInterface()
        }

    private func customizeNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
    }

        func updateUserInterface() {
            EmailLAbel.text = User1.email
            MobileNumberLabel.text = User1.phoneNumber
        }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white // Set text color to white
//            header.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold) // Optional: Adjust font size and weight
        }
    }

    @objc func handleButtonTap(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Verify Password", message: "Enter your current password", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Current Password"
            textField.isSecureTextEntry = true
        }
        
        let userPassword = User1.password
        
        let verifyAction = UIAlertAction(title: "Verify", style: .default) { _ in
            if let password = alertController.textFields?.first?.text, password == userPassword {
                if sender == self.EditEmailOrPhoneButton {
                    self.performSegue(withIdentifier: "EditEmailSegue", sender: nil)
                } else if sender == self.ChangePassword { // Use the correct outlet name
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
        
        if sender == self.EditEmailOrPhoneButton {
            performSegue(withIdentifier: "EditEmailSegue", sender: nil)
        } else if sender == self.ChangePassword {
            performSegue(withIdentifier: "ChangePasswordSegue", sender: nil)
        }
    }

        
        func showErrorMessage() {
            let errorAlert = UIAlertController(title: "Error", message: "Incorrect password. Please try again.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }

    
    
    func didUpdateEmailAndPhone(email: String, phone: String) {
            User1.email = email
            User1.phoneNumber = phone
            
            // Update the UI with the new values
            EmailLAbel.text = email
            MobileNumberLabel.text = phone
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "EditEmailSegue" {
                if let destinationVC = segue.destination as? EditMailAndPhoneTableViewController {
                    destinationVC.delegate = self
                }
            }
        }
}
