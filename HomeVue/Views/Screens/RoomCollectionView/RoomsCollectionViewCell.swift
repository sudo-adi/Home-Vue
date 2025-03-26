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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 3
        self.addCornerRadius(10)
    }
      
}
