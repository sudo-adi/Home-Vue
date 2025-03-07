//
//  UISegmentedControlExtension.swift
//  dummy
//
//  Created by student-2 on 15/01/25.
//

import Foundation
import UIKit

extension UISegmentedControl{
    func setCustomAppearance(selectedBackgroundColor: UIColor = .white,
                                 selectedTextColor: UIColor = .black,
                                 normalTextColor: UIColor = .white) {
        self.setTitleTextAttributes([.backgroundColor: selectedBackgroundColor,
                                     .foregroundColor: selectedTextColor], for: .selected)
        self.setTitleTextAttributes([.foregroundColor: normalTextColor], for: .normal)
    }
    
    func updateUI(emailTextField: UITextField, passwordTextField: UITextField,reEnterTextField:UITextField?=nil, phoneTextField: UITextField, parentView: UIView) {
        switch self.selectedSegmentIndex {
        case 0:
            emailTextField.isHidden = false
            passwordTextField.isHidden = false
            phoneTextField.isHidden = true
            if let reEnterTextField = reEnterTextField{
                reEnterTextField.isHidden = false
            }
        case 1:
            emailTextField.isHidden = true
            passwordTextField.isHidden = true
            phoneTextField.isHidden = false
            if let reEnterTextField = reEnterTextField{
                reEnterTextField.isHidden = true
            }
        default:
            break
        }
        UIView.animate(withDuration: 0.3) {
            parentView.layoutIfNeeded()
        }
    }
}
