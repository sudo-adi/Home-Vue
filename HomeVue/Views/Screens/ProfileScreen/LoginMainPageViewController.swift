//
//  LoginMainPageViewController.swift
//  Home Vue
//
//  Created by student-2 on 03/12/24.
//

import UIKit

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
                ("key.viewfinder", "Sign-in and Security", false)
            ]),
            ("Log-in", [
                ("rectangle.portrait.and.arrow.right", "Log out", true)
            ])
        ]

        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupView()
            profileView.image = User1.UserProfilePhoto
            personName.text = User1.UserName
            personEmail.text = User1.UserEmail
            lastBackgroundView.addRoundedCornersWithCutout(cornerRadius: 36, cutoutRadius: 80, cutoutCenter: CGPoint(x: lastBackgroundView.bounds.width / 2, y: 0))
            
            applyShadow(to: lastBackgroundView)
            
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

            
            // Profile outline
            outlineForProfile.addCornerRadius(outlineForProfile.frame.width / 2)
            outlineForProfile.layer.borderWidth = 4
            outlineForProfile.layer.borderColor = UIColor.solidBackgroundColor.cgColor
            outlineForProfile.backgroundColor = .clear

            // Profile image
            profileView.addCornerRadius(profileView.frame.width / 2)

            // Background view
            lastBackgroundView.backgroundColor = .solidBackgroundColor

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

            return cell
        }

        // MARK: - UITableView Delegate
         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedItem = tableData[indexPath.section].rows[indexPath.row].title

            // Map actions to segues or functions
            let segueMap: [String: String] = [
                "Personal Information": "PersonalInformation",
                "Sign-in and Security": "SignInAndSecurity"
            ]

            if let segueIdentifier = segueMap[selectedItem] {
                performSegue(withIdentifier: segueIdentifier, sender: nil)
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
            print("Logout functionality to be implemented here.")
            // Add logout logic, e.g., clearing user data or navigating to login screen
        }
    
    
    func applyShadow(to view: UIView,
                     color: UIColor = .brown,
                     opacity: Float = 1.0,
                     offset: CGSize = CGSize(width: 10, height: 10),
                     radius: CGFloat = 6,
                     cornerRadius: CGFloat = 10) {
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
        view.layer.cornerRadius = cornerRadius
    }

    
}
