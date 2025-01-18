//
//  UIViewControllerExtension.swift
//  dummy
//
//  Created by student-2 on 15/01/25.
//

import Foundation
import UIKit

extension UIViewController {
    func navigateToViewController(identifier: String) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func handleEmailLogin(email: String?, password: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            showAlert(message: "Please fill in both email and password.")
            return
        }
            
        navigateToViewController(identifier: "MainViewController")
    }

    func handlePhoneLogin(phone: String?) {
        guard let phone = phone, !phone.isEmpty else {
            showAlert(message: "Please enter your phone number.")
            return
        }
        navigateToViewController(identifier: "VerifyViewController")
    }
}

