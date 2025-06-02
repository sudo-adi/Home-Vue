//
//  ItemCollectionViewCell.swift
//  FurnitureCompositionView
//
//  Created by student-2 on 15/01/25.
//

import UIKit
class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ARButton: UIButton!
    @IBOutlet weak var ProductImg: UIImageView?
    @IBOutlet weak var ProductName: UILabel?
    @IBOutlet weak var ProductDimension: UILabel!
    @IBOutlet weak var ProductBrandName: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var item: FurnitureItem?
    private var favoriteToggleAction: ((FurnitureItem) -> Void)?
    private var arButtonAction: ((FurnitureItem) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ARButton.addCornerRadius()
        ARButton.imageView?.tintColor = .white
        
        self.addCornerRadius(15)
        
        
    }
    
    
    func configure(with item: FurnitureItem, favoriteToggleAction: @escaping (FurnitureItem) -> Void,arButtonAction: @escaping (FurnitureItem) -> Void) {
        self.item = item
        if let url = URL(string: item.imageURL!) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.ProductImg?.image = image
                    }
                }
            }.resume()
        }
//        ProductImg?.image = UIImage(named:item.imageName)x
        ProductName?.text = item.name!
        ProductBrandName?.text = item.brandName!
        ProductDimension?.text = "\(Int(item.dimensions[1]))W x \(Int(item.dimensions[2]))H x \(Int(item.dimensions[0]))D"
        self.favoriteToggleAction = favoriteToggleAction
        self.arButtonAction = arButtonAction
        
        // Update favorite button appearance
        updateFavoriteButtonAppearance()
    }
    
    func updateFavoriteButtonAppearance() {
        guard let item = item else { return }
        let isFavorite = UserDetails.shared.isFavoriteFurniture(furnitureID: item.id!)
        let imageName = isFavorite ? "heart.fill" : "heart"
        let tintColor = isFavorite ? UIColor.systemRed : UIColor.systemGray
        
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = tintColor
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        print("button tapped")
        guard let item = item, let action = favoriteToggleAction else { return }
        action(item)
        print("Item ID: \(item.id), Is favorite: \(UserDetails.shared.isFavoriteFurniture(furnitureID: item.id!))")
        // Update button appearance
        updateFavoriteButtonAppearance()
        
        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Add animation
        UIView.animate(withDuration: 0.1, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.favoriteButton.transform = CGAffineTransform.identity
            }
        }
    }
    
    @IBAction func arButtonTapped(_ sender: UIButton) {
        print("AR button tapped")
        guard let item = item, let action = arButtonAction else { return }
        action(item)
    }
}
