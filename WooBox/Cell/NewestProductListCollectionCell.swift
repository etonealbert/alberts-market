//
//  NewestProductListCollectionCell.swift

import UIKit
import Cosmos

class NewestProductListCollectionCell: UICollectionViewCell {

    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductRaing: UILabel!
    @IBOutlet weak var lblNewProductPrice: UILabel!
    @IBOutlet weak var lblOldProductPrice: UILabel!
    
    @IBOutlet weak var vwProductLikeBackground: UIView!
    @IBOutlet weak var vwProductRating: CosmosView!
    
    @IBOutlet weak var btnRating: UIButton!
    @IBOutlet weak var btnProductLike: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.layer.cornerRadius = 10.0
//        self.layer.masksToBounds = true
        
        vwProductLikeBackground.layer.cornerRadius = vwProductLikeBackground.frame.height / 2
        vwProductLikeBackground.layer.masksToBounds = true
        
        btnRating = THelper.setButtonTintColor(btnRating, imageName: "icoStar", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "Primary_Default_Color"))
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblOldProductPrice.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        lblOldProductPrice.attributedText = attributeString
        
        vwProductRating.settings.fillMode = .precise
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        constraintWidth.constant = SCREEN_SIZE.width-32

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
