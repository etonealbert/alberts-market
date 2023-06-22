//
//  NewestProductGridCollectionCell.swift

import UIKit
import Cosmos

class NewestProductGridCollectionCell: UICollectionViewCell {

    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var vwProductLkeBackground: UIView!
    @IBOutlet weak var vwProductColor: UIView!
    @IBOutlet weak var vwProductRating: CosmosView!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductNewPrice: UILabel!
    @IBOutlet weak var lblProductOldPrice: UILabel!
    
    @IBOutlet weak var btnProductLike: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.layer.cornerRadius = 10.0
//        self.layer.masksToBounds = true
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblProductNewPrice.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        lblProductNewPrice.attributedText = attributeString
        
        vwProductLkeBackground.layer.cornerRadius = vwProductLkeBackground.frame.height / 2
        vwProductLkeBackground.layer.masksToBounds = true
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        constraintWidth.constant = (SCREEN_SIZE.width / 2) - 16
        
        vwProductRating.settings.fillMode = .precise
        
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
