//
//  ChangePasswordTableViewController.swift
//  Home Vue
//
//  Created by student-2 on 19/12/24.
//

import UIKit

class ChangePasswordTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [ .foregroundColor: UIColor.gradientEndColor]
            navigationBar.tintColor = UIColor.gradientEndColor
        }
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.hideTabBar()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.applyGradientBackground()
    }
}
