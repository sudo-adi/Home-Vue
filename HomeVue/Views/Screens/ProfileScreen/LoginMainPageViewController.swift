//
//  LoginMainPageViewController.swift
//  Home Vue
//
//  Created by student-2 on 03/12/24.
// 

import UIKit

extension LoginMainPageViewController: PersonalInformationDelegate {
    func didUpdatePersonalInformation(profileImage: UIImage?, name: String, dateOfBirth: Date) {
        // Update the UI with the new values
        profileView.image = profileImage
        personName.text = name
        // Optionally update other UI components like the date of birth
    }
}

class LoginMainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileSectionTableView: UITableView!
    @IBOutlet weak var outlineForProfile: UIView!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var lastBackgroundView: UIView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personEmail: UILabel!
    
   

        // MARK: - Data Source
        let tableData: [(section: String, rows: [(icon: String, title: String, isRed: Bool)])] = [
            ("Account", [
                ("person.text.rectangle.fill", "Personal Information", false),
                ("key.viewfinder", "Sign-in and Security", false),
                ("heart.fill", "Favorites", false)
            ]),
            ("Log-in", [
                ("rectangle.portrait.and.arrow.right", "Log out", true)
            ])
        ]

        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupView()
            profileView.image = User1.profilePicture
            personName.text = User1.name
            personEmail.text = User1.email
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            customizeNavigationBar()
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            resetNavigationBarAppearance()
        }

        // MARK: - Setup Methods
        private func setupView() {
            // Gradient background
            view.applyGradientBackground()

            //Profile View
            profileView.addCornerRadius()
            profileView.layer.borderWidth = 4
            profileView.layer.borderColor = UIColor.solidBackgroundColor.cgColor
            profileView.backgroundColor = .clear

            // Profile outline
            outlineForProfile.addCornerRadius()
            outlineForProfile.layer.borderWidth = 5
            outlineForProfile.layer.borderColor = UIColor.gradientStartColor.cgColor
            outlineForProfile.backgroundColor = .clear

            // Background view
            lastBackgroundView.backgroundColor = .solidBackgroundColor
            lastBackgroundView.layer.cornerRadius = 30

            // Table view setup
            profileSectionTableView.dataSource = self
            profileSectionTableView.delegate = self
            profileSectionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            profileSectionTableView.backgroundColor = .solidBackgroundColor
        }

        private func customizeNavigationBar() {
            self.navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.titleFont()
            ]
        }

        private func resetNavigationBarAppearance() {
            self.navigationController?.navigationBar.titleTextAttributes = nil
        }

        // MARK: - UITableView DataSource
        func numberOfSections(in tableView: UITableView) -> Int {
            return tableData.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tableData[section].rows.count
        }

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return tableData[section].section.isEmpty ? nil : tableData[section].section
        }

         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let rowData = tableData[indexPath.section].rows[indexPath.row]

            // Configure cell appearance
            cell.textLabel?.text = rowData.title
            cell.textLabel?.font = UIFont.cellTextFont()
            cell.textLabel?.textColor = rowData.isRed ? .red : .gradientStartColor
            cell.imageView?.image = UIImage(systemName: rowData.icon)
            cell.imageView?.tintColor = rowData.isRed ? .red : .systemGray
            cell.accessoryType = .disclosureIndicator

             cell.accessoryType = rowData.title == "Log out" ? .none : .disclosureIndicator

            return cell
        }

        // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let selectedItem = tableData[indexPath.section].rows[indexPath.row].title

       // Map actions to segues or functions
       let segueMap: [String: String] = [
           "Personal Information": "PersonalInformation",
           "Sign-in and Security": "SignInAndSecurity",
           "Favorites": "Favorites"
       ]

        if let segueIdentifier = segueMap[selectedItem] {
            if segueIdentifier == "PersonalInformation" {
                // When navigating to PersonalInformationTableViewController, set the delegate
                if let personalInfoVC = storyboard?.instantiateViewController(withIdentifier: "PersonalInfo") as? PersonalInformationTableViewController {
                    personalInfoVC.delegate = self // Set the delegate here
                    navigationController?.pushViewController(personalInfoVC, animated: true)
                }
            } else if segueIdentifier == "Favorites" {
                // Navigate to FavoritesViewController
                if let favoritesVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesCollectionViewController") as? FavoritesCollectionViewController {
                    navigationController?.pushViewController(favoritesVC, animated: true)
                }
            } else {
                performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        } else if selectedItem == "Log out" {
            handleLogout()
        } else {
            print("No segue found for \(selectedItem)")
        }

        tableView.deselectRow(at: indexPath, animated: true)
   }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .gradientStartColor
            headerView.textLabel?.font = UIFont.headerFont()
        }
    }

        // MARK: - Helper Functions
    private func handleLogout() {
        let alertController = UIAlertController(title: "Log Out",
                                            message: "Are you sure you want to log out?",
                                            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            self.performLogout()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func performLogout() {
        print("Logging out...")

        // Instantiate HomeVueViewController from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeVueVC = storyboard.instantiateViewController(withIdentifier: "HomeVueViewController") as? homeVueViewController else {
            print("Failed to instantiate HomeVueViewController")
            return
        }
        
        let navigationController = UINavigationController(rootViewController: homeVueVC)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

    @IBAction func unwindToLoginMainPage(_ segue: UIStoryboardSegue) {
        // Update the main page UI if needed
        personEmail.text = User1.email
//        personPhone.text = User1.phoneNumber
    }

    
    
}
