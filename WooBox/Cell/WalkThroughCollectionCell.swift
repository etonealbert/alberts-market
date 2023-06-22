//
//  WalkThroughCollectionCell.swift

import UIKit

class WalkThroughCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgWalkThrough: UIImageView!
    
    @IBOutlet weak var vwImageBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 2.0, height: 10.0)
        self.layer.masksToBounds = false
        
        vwImageBackground.layer.cornerRadius = 10.0
        vwImageBackground.layer.masksToBounds = true
    }

}
