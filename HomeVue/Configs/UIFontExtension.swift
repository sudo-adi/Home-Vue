//
//  UIFontExtension.swift
//  Home Vue
//
//  Created by student-2 on 20/12/24.
//

import Foundation
import UIKit

extension UIFont {
    static func titleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 24, weight: .medium)
    }

    static func headerFont() -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .semibold)
    }

    static func cellTextFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }
}
