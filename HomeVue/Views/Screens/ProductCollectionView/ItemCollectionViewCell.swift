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
    
    private var item: FurnitureItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ARButton.addCornerRadius(ARButton.frame.height / 2)
        
        self.addCornerRadius(15)
    }
       
}
