////
////  ProductInfoTableViewController.swift
////  ProductDisplay
////
////  Created by Nishtha on 17/01/25.
////

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
        ARButton.addCornerRadius()
        title = furnitureItem.name
        updateUI()
        updateFavoriteButtonState()
        
        productSCNView.allowsCameraControl = true
        productSCNView.autoenablesDefaultLighting = true
        productSCNView.antialiasingMode = .multisampling2X
        productSCNView.backgroundColor = .white
    }

    private func updateFavoriteButtonState() {
    let isFavorite = UserDetails.shared.isFavoriteFurniture(furnitureID: furnitureItem.id)
    let imageName = isFavorite ? "heart.fill" : "heart"
    favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        UserDetails.shared.toggleSave(furnitureItem: furnitureItem)
        updateFavoriteButtonState()
        
        NotificationCenter.default.post(name: NSNotification.Name("FavoriteToggled"), object: nil)
    }
    
    private func updateUI() {
        if let modelName = furnitureItem?.model3D {
            if let scenePath = Bundle.main.path(forResource: modelName, ofType: nil) {
                let sceneURL = URL(fileURLWithPath: scenePath)
                do {
                    let scene = try SCNScene(url: sceneURL, options: nil)
                    productSCNView.scene = scene
                } catch {
                    print("Error loading 3D model: \(error)")
                }
            } else {
                print("❌ Error: 3D model \(modelName).usdz not found in '3D Model' folder.")
            }
        }
        nameLabel.text = furnitureItem?.name
        print(furnitureItem.name)
            brandNameLabel.text = furnitureItem?.brandName ?? "N/A"
            descriptionLabel.text = furnitureItem?.description ?? "N/A"
            
            if let dimensions = furnitureItem?.dimensions {
                heightLabel.text = "\(dimensions.height) cm"
                widthLabel.text = "\(dimensions.width) cm"
                depthLabel.text = "\(dimensions.depth) cm"
                
            } else {
                heightLabel.text = "N/A"
                widthLabel.text = "N/A"
                depthLabel.text = "N/A"
            }
            
            providersNameLabel.text = furnitureItem?.providers.map { $0.name }.joined(separator: ", ") ?? "N/A"
        }
    @IBAction func closeButtonTapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
            // Prepare the items to share
                var shareText = "Check out this furniture item!\n"
                shareText += "Name: \(furnitureItem.name)\n"
        shareText += "Brand: \(furnitureItem.brandName)\n"
        shareText += "Description: \(furnitureItem.description)\n"
        shareText += "Dimensions: \(furnitureItem.dimensions.height) x \(furnitureItem.dimensions.width) x \(furnitureItem.dimensions.depth) cm\n"
        shareText += "Providers: \(furnitureItem.providers.map { $0.name }.joined(separator: ", "))"

                var itemsToShare: [Any] = [shareText]
                
                // Optionally include the image if available
                    itemsToShare.append(furnitureItem.image)
                
                
                // Create the UIActivityViewController
                let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)

                
                // Present the share sheet
                self.present(activityViewController, animated: true, completion: nil)

        }
    @IBAction func navigateToSwiftUI(_ sender: Any) {
        // Get the model category using the helper function
        let modelCategory = Model.getCategoryFromModel3D(furnitureItem.model3D)
        
        // Create a Model object for the selected furniture
        let model = Model(name: furnitureItem.model3D.replacingOccurrences(of: ".usdz", with: ""), category: modelCategory)
        model.asyncLoadModelEntity()
        
        // Create placement settings with the selected model
        let placementSettings = PlacementSettings()
        placementSettings.selectedModel = model
        
        // Create content view with the selected model and disable browse
        let contentView = ContentView(allowBrowse: false)
            .environmentObject(placementSettings)
            .environmentObject(SessionSettings())
        
        self.presentFullScreen(contentView)
    }
}
