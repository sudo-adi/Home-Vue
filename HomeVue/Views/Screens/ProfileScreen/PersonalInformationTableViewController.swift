//
//  PersonalInformationTableViewController.swift
//  Home Vue
//
//  Created by student-2 on 11/12/24.
//

import UIKit

class PersonalInformationTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var NameLabel: UITextField!
    @IBOutlet weak var DateLabel: UILabel!
    
    let datePickerContainer = UIView()
    let datePicker = UIDatePicker()

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
            
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [ .foregroundColor: UIColor.gradientEndColor]
            navigationBar.tintColor = UIColor.gradientEndColor
                
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        DateLabel.isUserInteractionEnabled = true
        DateLabel.addGestureRecognizer(tapGesture)
        updateDateLabel(with: Date())
        ProfileImage?.addCornerRadius()
        view.backgroundColor = .solidBackgroundColor

        ProfileImage.image = User1.profilePicture
        NameLabel.text = User1.name
        setDateLabel(with: User1.dateOfBirth!)
        
        self.view.applyGradientBackground()
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
        datePicker.frame = CGRect(x: 0, y: view.bounds.height - 100, width: view.bounds.width, height: 100)
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        datePicker.contentHorizontalAlignment = .center
        datePicker.contentVerticalAlignment = .center
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: view.bounds.height - 150, width: view.bounds.width, height: 50))
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
    
    
    
}
