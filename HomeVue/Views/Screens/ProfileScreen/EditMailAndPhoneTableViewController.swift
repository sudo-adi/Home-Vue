//
//  EditMailAndPhoneTableViewController.swift
//  Home Vue
//
//  Created by student-2 on 19/12/24.
//

import UIKit

class EditMailAndPhoneTableViewController: UITableViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
               
           if let navigationBar = self.navigationController?.navigationBar {
               navigationBar.titleTextAttributes = [ .foregroundColor: UIColor.gradientEndColor]
               navigationBar.tintColor = UIColor.gradientEndColor
           }
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()

           EmailTextField.text = User1.UserEmail
           PhoneTextField.text = User1.mobile
           
           // Apply gradient background
           applyGradientBackground(to: self.view,
                                   startColor: .gradientStartColor,
                                   endColor: .gradientEndColor)
       }
       
       // MARK: - Table View Data Source

       override func numberOfSections(in tableView: UITableView) -> Int {
           return 2 // Two sections: Edit Email and Edit Phone Number
       }

       override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           switch section {
           case 0:
               return "Edit Email"
           case 1:
               return "Edit Phone Number"
           default:
               return nil
           }
       }
       
       // MARK: - Table View Delegate

       override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
           if let header = view as? UITableViewHeaderFooterView {
               header.textLabel?.textColor = .white // Set the text color to white
               header.textLabel?.font = UIFont.headerFont() // Set the custom font
           }
       }

}
