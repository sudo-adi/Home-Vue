import UIKit
protocol PersonalInformationDelegate: AnyObject {
    func didUpdatePersonalInformation(profileImage: UIImage?, name: String, dateOfBirth: String)
}

class PersonalInformationTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: PersonalInformationDelegate?
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var NameLabel: UITextField!
    @IBOutlet weak var DateLabel: UILabel!
    
    let datePickerContainer = UIView()
    let datePicker = UIDatePicker()
    var authManager = AuthManager()
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }

    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in
                print("User has chosen camera")
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in
                print("User has chosen photo library")
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        ProfileImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBar()

        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.hideTabBar()
        }
        
        // Fetch updated user data
        authManager.refreshUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.loadUserData()
                case .failure(let error):
                    print("Error refreshing user: \(error)")
                    self.ProfileImage.image = UIImage(named: "placeholder")
                    self.NameLabel.text = ""
                    self.DateLabel.text = ""
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the tab bar again when leaving this screen
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        self.hidesBottomBarWhenPushed = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        DateLabel.isUserInteractionEnabled = true
        DateLabel.addGestureRecognizer(tapGesture)
        updateDateLabel(with: Date())
        ProfileImage?.addCornerRadius()
        self.view.applyGradientBackground()
        
        loadUserData()
    }
    
    private func loadUserData() {
        if let user = authManager.currentUser {
            if let urlString = authManager.currentUser?.profilePicture,
               let url = URL(string: urlString), !urlString.isEmpty {
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard let self = self, let data = data, error == nil,
                          let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                            self?.ProfileImage.image = UIImage(named: "Default")
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        self.ProfileImage.image = image
                    }
                }.resume()
            }else{
                ProfileImage.image = UIImage(named: "Default")
            }
            
            NameLabel.text = user.name
            if let dobString = user.dateOfBirth, let dob = convertDateStringToDate(dobString) {
                setDateLabel(with: dob)
            } else {
                updateDateLabel(with: Date())
            }
        } else {
            ProfileImage.image = UIImage(named: "placeholder")
            NameLabel.text = ""
            updateDateLabel(with: Date())
        }
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

   private func setDateLabel(with date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    DateLabel.text = dateFormatter.string(from: date)
}

    @objc func showDatePicker() {
        datePickerContainer.frame = view.bounds
        datePickerContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        datePicker.frame = CGRect(x: 0, y: view.bounds.height - 180, width: view.bounds.width, height: 100)
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        datePicker.contentHorizontalAlignment = .center
        datePicker.contentVerticalAlignment = .center
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: view.bounds.height - 230, width: view.bounds.width, height: 50))
        toolbar.items = [
               UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissDatePicker)),
               UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
               UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(datePickerSet))
        ]
        toolbar.backgroundColor = .white
        // Add the date picker and toolbar to the container
        datePickerContainer.addSubview(toolbar)
        datePickerContainer.addSubview(datePicker)
        // Add the container to the main view
        view.addSubview(datePickerContainer)
    }

    @objc func dismissDatePicker() {
        datePickerContainer.removeFromSuperview()
    }

    @objc func datePickerSet() {
        updateDateLabel(with: datePicker.date)
        dismissDatePicker()
    }

    private func updateDateLabel(with date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy" // Custom format: 2024-05-18
    DateLabel.text = dateFormatter.string(from: date)
}
    
    @IBAction func SaveButtonTap(_ sender: UIBarButtonItem) {
        guard let newName = NameLabel.text, !newName.isEmpty else {
             let alert = UIAlertController(title: "Error", message: "Name cannot be empty", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default))
             present(alert, animated: true)
             return
         }

         // Now, just use the date string directly
         guard let dateText = DateLabel.text, !dateText.isEmpty else {
             let alert = UIAlertController(title: "Error", message: "Invalid date format", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default))
             present(alert, animated: true)
             return
            }
            let newImage = ProfileImage.image

            if let imageToUpload = newImage {
                authManager.uploadProfileImage(userId: authManager.currentUser!.id, image: imageToUpload) { result in
                    switch result {
                    case .success(let imageURL):
                        print("Profile image updated successfully: \(imageURL)")
                    case .failure(let error):
                        print("Error uploading profile image: \(error)")
                    }
                }
            }
            delegate?.didUpdatePersonalInformation(
                profileImage: newImage,
                name: newName,
                dateOfBirth: dateText
            )
            navigationController?.popViewController(animated: true)
}

    // Helper function to save UIImage to disk
//    private func saveImageToDisk(image: UIImage) -> String? {
//        guard let data = image.jpegData(compressionQuality: 1.0) else {
//            print("Failed to convert image to JPEG data")
//            return nil
//        }
//        let fileName = UUID().uuidString + ".jpg"
//        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
//        do {
//            try data.write(to: fileURL)
//            return fileName
//        } catch {
//            print("Error saving image to disk: \(error)")
//            return nil
//        }
//    }
    private func convertDateStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: dateString)
    }
}
