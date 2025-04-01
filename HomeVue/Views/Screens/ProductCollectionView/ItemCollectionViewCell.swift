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
    
    private var item: FurnitureItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ARButton.addCornerRadius()
        
        self.addCornerRadius(15)
    }
       
}
