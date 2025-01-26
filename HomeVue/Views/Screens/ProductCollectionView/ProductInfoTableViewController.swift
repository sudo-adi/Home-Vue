////
////  ProductInfoTableViewController.swift
////  ProductDisplay
////
////  Created by Nishtha on 17/01/25.
////

import UIKit

class ProductInfoTableViewController: UITableViewController {
    var furnitureItem: FurnitureItem!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var providersNameLabel: UILabel!
    @IBOutlet weak var ARButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        guard furnitureItem != nil else {
           print("Furniture item not set!")
           return
       }
        ARButton.addCornerRadius()
        title = furnitureItem.name
            updateUI()
    }
    private func updateUI() {
        productImageView.image = furnitureItem?.image
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
}
