//
//  EditMailAndPhoneTableViewController.swift
//  Home Vue
//
//  Created by student-2 on 19/12/24.
//

import UIKit

protocol EditMailAndPhoneDelegate: AnyObject {
    func didUpdateEmailAndPhone(email: String, phone: String)
}

class EditMailAndPhoneTableViewController: UITableViewController {

    weak var delegate: EditMailAndPhoneDelegate?
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    
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

           customizeNavigationBar()
           
           EmailTextField.text = User1.email
//           PhoneTextField.text = User1.phoneNumber
           
           // Apply gradient background
           self.view.applyGradientBackground()
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

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // Save the changes to the user object
        if let updatedEmail = EmailTextField.text, let updatedPhone = PhoneTextField.text {
            // Pass data to the delegate
            delegate?.didUpdateEmailAndPhone(email: updatedEmail, phone: updatedPhone)
        }
        // Go back to the previous screen
        navigationController?.popViewController(animated: true)
    }
}
