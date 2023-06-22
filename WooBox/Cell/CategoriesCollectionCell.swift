//
//  CategoriesCollectionCell.swift

import UIKit

class CategoriesCollectionCell: UICollectionViewCell {

    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 20.0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.primaryColor().cgColor
        self.layer.masksToBounds = true
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        constraintWidth.constant = SCREEN_SIZE.width-16
        
        if #available(iOS 12.0, *) {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            // Code below is needed to make the self-sizing cell work when building for iOS 12 from Xcode 10.0:
            let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
            let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
            let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
            let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        }
    }

}
