//
//  UIBackground.swift
//  Home Vue
//
//  Created by student-2 on 23/12/24.
//

import UIKit

class UIBackground {
    /// Sets a background image for a UITableView.
    /// - Parameters:
    ///   - tableView: The UITableView to set the background image for.
    ///   - imageName: The name of the image in the assets catalog.
    static func setTableViewBackground(_ tableView: UITableView, withImageNamed imageName: String) {
        guard let backgroundImage = UIImage(named: imageName) else {
            print("Error: Image \(imageName) not found")
            return
        }
        
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill // Adjust scaling as needed
        tableView.backgroundView = backgroundImageView
    }
}

