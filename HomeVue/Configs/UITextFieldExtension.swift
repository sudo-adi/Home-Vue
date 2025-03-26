//
//  UITextFieldExtension.swift
//  dummy
//
//  Created by student-2 on 15/01/25.
//

import Foundation
import UIKit

extension UITextField {
    func removeCursor() {
        self.tintColor = .clear // Makes the cursor invisible
    }

    func setPadding(left: CGFloat, right: CGFloat = 0) {
        // Add padding to the left
        if left > 0 {
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: 1))
            self.leftView = leftPaddingView
            self.leftViewMode = .always
        }
        
        // Add padding to the right
        if right > 0 {
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: 1))
            self.rightView = rightPaddingView
            self.rightViewMode = .always
        }
    }
    
    
    func configureText(placeholder: String, placeholderColor: UIColor = .lightGray){
        // Set placeholder with attributes
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: placeholderColor]
        )
    }
    
    func setPhoneNumberValidation() {
            self.delegate = self
        }
}

extension UITextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
               let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
               
               let allowedCharacters = CharacterSet.decimalDigits
               let characterSet = CharacterSet(charactersIn: string)
               let isNumeric = allowedCharacters.isSuperset(of: characterSet)
               
               return updatedText.count <= 10 && isNumeric
           }
       }
