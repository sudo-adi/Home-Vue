import UIKit
class signAndSecurityTableViewController: UITableViewController {

    @IBOutlet weak var emailLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
            // Fetch updated user data
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.hideTabBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        customizeNavigationBar()
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.showTabBar()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//            view.backgroundColor = .solidBackgroundColor
        customizeNavigationBar()
        emailLabel.text = User1.email
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
    
    @IBAction func logoutTapped(_ sender: Any) {
        showLogoutAlert()
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
        showDeleteAccountAlert()
    }
    // MARK: - Table View Delegate for Cell Selection

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        switch indexPath.row {
//        case 1:
//            showLogoutAlert()
//        case 2:
//            showDeleteAccountAlert()
//        default:
//            break // Email cell — non-interactive
//        }
//    }
    
    
    private func showLogoutAlert() {
            let alert = UIAlertController(
                title: "Logout",
                message: "Are you sure you want to logout?",
                preferredStyle: .alert
            )

            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
                self?.redirectToHome()
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            alert.addAction(logoutAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
        }

        private func showDeleteAccountAlert() {
            let alert = UIAlertController(
                title: "Delete Account",
                message: "Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.",
                preferredStyle: .alert
            )

            alert.addTextField { textField in
                textField.placeholder = "Type 'DELETE' to confirm"
                textField.autocapitalizationType = .allCharacters
            }

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let confirmText = alert.textFields?.first?.text,
                      confirmText == "DELETE" else {
                    self?.showErrorAlert(message: "Please type 'DELETE' to confirm account deletion")
                    return
                }

                self?.handleAccountDeletion()
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            alert.addAction(deleteAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
        }

    private func showErrorAlert(message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(errorAlert, animated: true)
    }

    private func handleAccountDeletion() {
        // TODO: Add backend account deletion logic here
        redirectToHome()
    }
    
    private func redirectToHome() {
        // Navigate to HomevueViewController
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVueViewController")
            window.rootViewController = UINavigationController(rootViewController: homeVC)
            window.makeKeyAndVisible()
        }
    }
}
