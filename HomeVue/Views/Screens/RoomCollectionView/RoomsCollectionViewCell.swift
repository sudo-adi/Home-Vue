//
//  RoomsCollectionViewCell.swift
//  ProductDisplay
//
//  Created by Nishtha on 18/01/25.
//

import UIKit

class RoomsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    func configure(with room: RoomModel) {
        nameLabel.text = room.details.name
        dateCreatedLabel.text = "Created on: \(room.details.createdDate.formatted())"
        
        // Generate thumbnail from 3D model
        if let modelPath = room.details.model3D,
           let modelURL = URL(string: modelPath) {
            DispatchQueue.global(qos: .background).async {
                if let thumbnail = ThumbnailGenerator.generateThumbnail(from: modelURL) {
                    DispatchQueue.main.async {
                        self.roomImage.image = thumbnail
                    }
                } else {
                    DispatchQueue.main.async {
                        self.roomImage.image = UIImage(named: "model_img")
                    }
                }
            }
        } else {
            roomImage.image = UIImage(named: "model_img")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 3
        self.addCornerRadius(10)
    }
      
    override func prepareForReuse() {
        super.prepareForReuse()
        roomImage.image = UIImage(named: "model_img")
        nameLabel.text = nil
        dateCreatedLabel.text = nil
    }
        
}
