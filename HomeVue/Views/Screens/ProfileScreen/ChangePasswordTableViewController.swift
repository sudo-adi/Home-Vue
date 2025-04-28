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
            
        customizeNavigationBar()
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
        customizeNavigationBar()
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
}
