//
//  CategoryCollectionViewCell.swift

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vwIcon: UIView!
    @IBOutlet weak var imgCategories: UIImageView!
    @IBOutlet weak var lblCategories: UILabel!
    
    @IBOutlet weak var vwCategory: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwIcon.layer.cornerRadius = vwIcon.frame.height / 2
    }

}
