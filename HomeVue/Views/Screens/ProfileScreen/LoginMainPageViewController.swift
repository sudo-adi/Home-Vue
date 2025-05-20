import UIKit
import Storage


extension LoginMainPageViewController: PersonalInformationDelegate {
    func didUpdatePersonalInformation(profileImage: UIImage?, name: String, dateOfBirth: String) {
        personName.text = name
        if let image = profileImage, let userId = authManager.currentUser?.id {
            profileView.image = image
            
            authManager.uploadProfileImage(userId: userId, image: image) { [weak self] result in
                DispatchQueue.main.async {
                    if var updatedUser = self?.authManager.currentUser {
                        switch result {
                        case .success(let imageUrl):
                            updatedUser.profilePicture = imageUrl
                        case .failure:
                            updatedUser.profilePicture = nil
                        }
                        updatedUser.name = name
                        updatedUser.dateOfBirth = "\(dateOfBirth)"
                        self?.authManager.updateUserProfile(user: updatedUser) { result in
                            switch result {
                            case .success:
                                print("User profile updated successfully")
                            case .failure(let error):
                                print("Error updating user profile: \(error)")
                            }
                        }
                    }
                }
            }
        } else {
            if var updatedUser = authManager.currentUser {
                updatedUser.profilePicture = nil
                updatedUser.name = name
                updatedUser.dateOfBirth = "\(dateOfBirth)"
                authManager.updateUserProfile(user: updatedUser) { result in
                    switch result {
                    case .success:
                        print("User profile updated successfully")
                    case .failure(let error):
                        print("eororororooror: \(error)")
                    }
                }
            }
        }
    }
}
class LoginMainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var profileSectionTableView: UITableView!
    @IBOutlet weak var outlineForProfile: UIView!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var lastBackgroundView: UIView!
    @IBOutlet weak var personName: UILabel!
    
    var authManager = AuthManager()
    
    // MARK: - Data Source
    let tableData: [(section: String, rows: [(icon: String, title: String, isRed: Bool)])] = [
        ("Account", [
            ("person.text.rectangle.fill", "Personal Information", false),
            ("key.viewfinder", "Sign-in and Security", false),
            ("heart.fill", "Favorites", false)
        ])
    ]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        customizeNavigationBar()
        updateUIWithUserDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBar()
        // Refresh user data
        authManager.refreshUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updateUIWithUserDetails()
                case .failure(let error):
                    print("Error refreshing user: \(error)")
                    self.profileView.image = UIImage(named: "placeholder")
                    self.personName.text = "User"
                }
            }
        }
    }

    // MARK: - Setup Methods
    private func setupView() {
        // Gradient background
        view.applyGradientBackground()

        // Profile View
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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .gradientStartColor

        // Customize the title appearance
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.titleFont()
        ]
        
        // Apply the appearance to all bar states
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }

    // MARK: - Helper Functions
    private func updateUIWithUserDetails() {
        if let user = authManager.currentUser {
            // Load profile picture
            if let imageName = user.profilePicture {
                if imageName.hasPrefix("http"), let url = URL(string: imageName) {
                    // Load from URL
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.profileView.image = image
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.profileView.image = UIImage(named: "placeholder")
                            }
                        }
                    }.resume()
                } else {
                    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(imageName)
                    if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                        self.profileView.image = image
                    } else if let image = UIImage(named: imageName) {
                        self.profileView.image = image
                    } else {
                        self.profileView.image = UIImage(named: "placeholder")
                    }
                }
            } else {
                self.profileView.image = UIImage(named: "placeholder")
            }
            self.personName.text = user.name?.isEmpty == false ? user.name : "User"
        } else {
            self.profileView.image = UIImage(named: "placeholder")
            self.personName.text = "User"
        }
    }
    
    private func saveImageToDisk(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert image to JPEG data")
            return nil
        }
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image to disk: \(error)")
            return nil
        }
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
        cell.textLabel?.textColor = rowData.isRed ? .red : .systemGray
        cell.imageView?.image = UIImage(systemName: rowData.icon)
        cell.imageView?.tintColor = rowData.isRed ? .red : .systemGray
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white

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
                    personalInfoVC.delegate = self
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

    @IBAction func unwindToLoginMainPage(_ segue: UIStoryboardSegue) {
        updateUIWithUserDetails()
    }
}
