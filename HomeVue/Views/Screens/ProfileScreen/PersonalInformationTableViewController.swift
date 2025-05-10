import UIKit

// In PersonalInformationTableViewController.swift
protocol PersonalInformationDelegate: AnyObject {
    func didUpdatePersonalInformation(profileImage: UIImage?, name: String, dateOfBirth: Date)
}

class PersonalInformationTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: PersonalInformationDelegate?
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var NameLabel: UITextField!
    @IBOutlet weak var DateLabel: UILabel!
    
    let datePickerContainer = UIView()
    let datePicker = UIDatePicker()

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
                let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in print("User has chosen camera")
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                })
                alertController.addAction(cameraAction)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in print("User has chosen photo library")
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                })
                alertController.addAction(photoLibraryAction)
            }
            
            present(alertController, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else {return}
            ProfileImage.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBar()

        // Hide the tab bar when this screen appears
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.hideTabBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        resetNavigationBarAppearance()

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
//        view.backgroundColor = .solidBackgroundColor

        ProfileImage.image = User1.profilePicture
        NameLabel.text = User1.name
        setDateLabel(with: User1.dateOfBirth!)
        
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

    
    private func setDateLabel(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // Example: Dec 19, 2024
        dateFormatter.timeStyle = .none // No time
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
        // Remove the date picker container from the view
        datePickerContainer.removeFromSuperview()
    }

    @objc func datePickerSet() {
        // Update the DateLabel with the selected date
        updateDateLabel(with: datePicker.date)
        // Dismiss the date picker container
        dismissDatePicker()
    }

    private func updateDateLabel(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        DateLabel.text = dateFormatter.string(from: date)
    }
    
    

    
    @IBAction func SaveButtonTap(_ sender: UIBarButtonItem) {
        
        if let newName = NameLabel.text, !newName.isEmpty {
            User1.name = newName
        }
        
        // Update the date of birth
        if let dateText = DateLabel.text, let date = convertDateStringToDate(dateText) {
            User1.dateOfBirth = date
        }
        
        // Update the profile picture
        if let updatedImage = ProfileImage.image {
            User1.profilePicture = updatedImage
        }
        
        // Notify the delegate of the changes
        delegate?.didUpdatePersonalInformation(profileImage: ProfileImage.image, name: NameLabel.text ?? "", dateOfBirth: User1.dateOfBirth ?? Date())
        
        // Pop the view controller to go back to the previous screen
        navigationController?.popViewController(animated: true)
    }

    private func convertDateStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.date(from: dateString)
    }
}



