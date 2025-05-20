////
////  EditMailAndPhoneTableViewController.swift
////  Home Vue
////
////  Created by student-2 on 19/12/24.
////
import UIKit

protocol EditMailDelegate: AnyObject {
    func didUpdateEmail(email: String)
}

class EditMailTableViewController: UITableViewController {
    weak var delegate: EditMailDelegate?
    var authManager = AuthManager()
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBar()
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.hideTabBar()
        }
        
        // Refresh user data
        authManager.refreshUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.loadUserData()
                case .failure(let error):
                    print("Error refreshing user: \(error)")
                    self.EmailTextField.text = ""
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        self.view.applyGradientBackground()
        loadUserData()
    }
    
    private func loadUserData() {
        EmailTextField.text = authManager.currentUser?.email ?? ""
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
        return "Edit Email"
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white // Set the text color to white
            header.textLabel?.font = UIFont.headerFont() // Set the custom font
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let updatedEmail = EmailTextField.text, !updatedEmail.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Email cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Update the email in Supabase
        if var updatedUser = authManager.currentUser {
            updatedUser.email = updatedEmail
            authManager.updateUserProfile(user: updatedUser) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        // Pass data to the delegate
                        self.delegate?.didUpdateEmail(email: updatedEmail)
                        // Go back to the previous screen
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        let alert = UIAlertController(title: "Error", message: "Failed to update email: \(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "No user data available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
