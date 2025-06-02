//////
//////  ProductInfoTableViewController.swift
//////  ProductDisplay
//////
//////  Created by Nishtha on 17/01/25.
//////
//
//import UIKit
//import SceneKit
//
//class ProductInfoTableViewController: UITableViewController {
//    var furnitureItem: FurnitureItem!
//    
//    @IBOutlet weak var productSCNView: SCNView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var brandNameLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var heightLabel: UILabel!
//    @IBOutlet weak var widthLabel: UILabel!
//    @IBOutlet weak var depthLabel: UILabel!
//    @IBOutlet weak var providersNameLabel: UILabel!
//    @IBOutlet weak var ARButton: UIButton!
//    @IBOutlet weak var favoriteButton: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        guard furnitureItem != nil else {
//           print("Furniture item not set!")
//           return
//        }
//        
//        tableView.backgroundColor = .white
//        view.backgroundColor = .white
//        
//        ARButton.addCornerRadius()
//        ARButton.imageView?.tintColor = .white
//        title = furnitureItem.name
//        updateUI()
//        updateFavoriteButtonState()
//        
//        productSCNView.allowsCameraControl = true
//        productSCNView.autoenablesDefaultLighting = true
//        productSCNView.antialiasingMode = .multisampling2X
//        productSCNView.backgroundColor = .white
//    }
//
//    private func updateFavoriteButtonState() {
//        let isFavorite = UserDetails.shared.isFavoriteFurniture(furnitureID: furnitureItem.id!)
//    let imageName = isFavorite ? "heart.fill" : "heart"
//    favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
//    }
//
//    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
//        UserDetails.shared.toggleSave(furnitureItem: furnitureItem)
//        updateFavoriteButtonState()
//        
//        NotificationCenter.default.post(name: NSNotification.Name("FavoriteToggled"), object: nil)
//    }
//    
//    private func updateUI() {
//        if let modelURLString = furnitureItem?.model3D, let modelURL = URL(string: modelURLString) {
//            let sceneSource: SCNScene?
//            if modelURL.isFileURL {
//                sceneSource = SCNScene(named: modelURL.path)
//            } else {
//                // Download the model data asynchronously
//                DispatchQueue.global().async {
//                    if let data = try? Data(contentsOf: modelURL),
//                       let tempURL = try? self.saveTempModel(data: data, fileExtension: modelURL.pathExtension) {
//                        do {
//                            let scene = try SCNScene(url: tempURL, options: nil)
//                            DispatchQueue.main.async {
//                                self.productSCNView.scene = scene
//                            }
//                        } catch {
//                            print("❌ Failed to load scene from URL: \(error)")
//                        }
//                    } else {
//                        print("DEBUG: Failed to download or load model from URL: \(modelURL)")
//                    }
//                }
//                return
//            }
//            if let scene = sceneSource {
//                productSCNView.scene = scene
//            }
//        }
//        nameLabel.text = furnitureItem?.name
//        brandNameLabel.text = furnitureItem?.brandName ?? "N/A"
//        descriptionLabel.text = furnitureItem?.description ?? "N/A"
//        if let dimensions = furnitureItem?.dimensions {
//            heightLabel.text = "\(dimensions[0]) cm"
//            widthLabel.text = "\(dimensions[1]) cm"
//            depthLabel.text = "\(dimensions[2]) cm"
//        } else {
//            heightLabel.text = "N/A"
//            widthLabel.text = "N/A"
//            depthLabel.text = "N/A"
//        }
//        providersNameLabel.text = furnitureItem?.providers?.joined(separator: ", ") ?? "N/A"
//    }
//
//    // Helper to save temp model file
//    private func saveTempModel(data: Data, fileExtension: String) throws -> URL {
//        let tempDir = FileManager.default.temporaryDirectory
//        let fileURL = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension(fileExtension)
//        try data.write(to: fileURL)
//        return fileURL
//    }
//
//    @IBAction func closeButtonTapped(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @IBAction func shareButtonTapped(_ sender: Any) {
//            // Prepare the items to share
//        var shareText = "Check out this furniture item!\n"
//        shareText += "Name: \(furnitureItem.name!)\n"
//        shareText += "Brand: \(furnitureItem.brandName!)\n"
//        shareText += "Description: \(furnitureItem.description!)\n"
//        shareText += "Dimensions: \(furnitureItem.dimensions[0]) x \(furnitureItem.dimensions[1]) x \(furnitureItem.dimensions[2]) cm\n"
//        shareText += "Providers: \(furnitureItem.providers!.map { $0}.joined(separator: ", "))"
//
//        var itemsToShare: [Any] = [shareText]
//        if let url = URL(string: furnitureItem.imageURL!) {
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                    itemsToShare.append(image)
//                    }
//                }
//            }.resume()
//        }
//        
//        
//        // Create the UIActivityViewController
//        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
//
//        
//        // Present the share sheet
//        self.present(activityViewController, animated: true, completion: nil)
//
//    }
//    
//    @IBAction func ARButtonTapped(_ sender: Any) {
//        ARViewPresenter.presentARView(for: furnitureItem, allowBrowse: false, from: self)
//    }
//}
//
//  ProductInfoTableViewController.swift
//  ProductDisplay
//
//  Created by Nishtha on 17/01/25.
//

import UIKit
import SceneKit

class ProductInfoTableViewController: UITableViewController {
    var furnitureItem: FurnitureItem!
    
    @IBOutlet weak var productSCNView: SCNView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var providersNameLabel: UILabel!
    @IBOutlet weak var ARButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard furnitureItem != nil else {
            print("Furniture item not set!")
            return
        }
        
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        
        ARButton.addCornerRadius()
        ARButton.imageView?.tintColor = .white
        title = furnitureItem.name
        updateUI()
        updateFavoriteButtonState()
        
        productSCNView.allowsCameraControl = true
        productSCNView.autoenablesDefaultLighting = true
        productSCNView.antialiasingMode = .multisampling2X
        productSCNView.backgroundColor = .white
    }

    private func updateFavoriteButtonState() {
        let isFavorite = UserDetails.shared.isFavoriteFurniture(furnitureID: furnitureItem.id!)
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        UserDetails.shared.toggleSave(furnitureItem: furnitureItem)
        updateFavoriteButtonState()
        
        NotificationCenter.default.post(name: NSNotification.Name("FavoriteToggled"), object: nil)
    }
    
    private func updateUI() {
        // Update labels
        nameLabel.text = furnitureItem?.name
        brandNameLabel.text = furnitureItem?.brandName ?? "N/A"
        descriptionLabel.text = furnitureItem?.description ?? "N/A"
        if let dimensions = furnitureItem?.dimensions {
            heightLabel.text = "\(dimensions[2]) cm"
            widthLabel.text = "\(dimensions[1]) cm"
            depthLabel.text = "\(dimensions[0]) cm"
        } else {
            heightLabel.text = "N/A"
            widthLabel.text = "N/A"
            depthLabel.text = "N/A"
        }
        providersNameLabel.text = furnitureItem?.providers?.joined(separator: ", ") ?? "N/A"

        Task {
            do {
                let remoteURL = URL(string:furnitureItem.model3D!)!
                let rawName = furnitureItem.name ?? "model"
                let safeName = rawName.replacingOccurrences(of: " ", with: "_")
                                    .replacingOccurrences(of: "/", with: "-")
                let fileName = "\(safeName).usdz"

                let localURL = try await downloadModelIfNeeded(from: remoteURL, fileName: fileName)

                let scene = try SCNScene(url: localURL, options: nil)
                productSCNView.scene = scene
            } catch {
                print("❌ Failed to load SceneKit model: \(error)")
            }
        }

    }
    func getCachedModelURL(for filename: String) -> URL {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDir.appendingPathComponent(filename)
    }

    func downloadModelIfNeeded(from remoteURL: URL, fileName: String) async throws -> URL {
        let localURL = getCachedModelURL(for: fileName)

        if FileManager.default.fileExists(atPath: localURL.path) {
            print("Using cached model at \(localURL.lastPathComponent)")
            return localURL
        }

        print("Downloading model from Supabase...")
        let (data, _) = try await URLSession.shared.data(from: remoteURL)

        try data.write(to: localURL, options: .atomic)
        print("Model cached at \(localURL.lastPathComponent)")
        return localURL
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        // Prepare the items to share
        var shareText = "Check out this furniture item!\n"
        shareText += "Name: \(furnitureItem.name!)\n"
        shareText += "Brand: \(furnitureItem.brandName ?? "N/A")\n"
        shareText += "Dimensions: \(furnitureItem.dimensions[0]) x \(furnitureItem.dimensions[1]) x \(furnitureItem.dimensions[2]) cm\n"
        shareText += "Providers: \(furnitureItem.providers?.joined(separator: ", ") ?? "N/A")"

        var itemsToShare: [Any] = [shareText]
        if let urlString = furnitureItem.imageURL, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        itemsToShare.append(image)
                        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                }
            }.resume()
        } else {
            let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func ARButtonTapped(_ sender: Any) {
//        ARViewPresenter.presentARView(for: furnitureItem, allowBrowse: false, from: self)
        Task {
                    await ARViewPresenter.presentARView(
                        for: furnitureItem,
                        allowBrowse: false,
                        from: self
                    )
                }
    }
}

extension FileManager {
    var cachesDirectory: URL {
        urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}

