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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        applyGradientBackground(to: self.view,
                                    startColor: .gradientStartColor,
                                    endColor: .gradientEndColor)
    }

    
    
    
    
    

}
