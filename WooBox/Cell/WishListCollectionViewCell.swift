//
//  WishListCollectionViewCell.swift

import UIKit

class WishListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblNewPrice: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblMoveToCart: UILabel!
    @IBOutlet weak var lblRemove: UILabel!
    
    @IBOutlet weak var btnMoveToCart: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code.
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblOldPrice.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        lblOldPrice.attributedText = attributeString
        self.lblMoveToCart.text = LanguageLocal.myLocalizedString(key: "Move_to_Cart")
        self.lblRemove.text = LanguageLocal.myLocalizedString(key: "Remove")
    }

}
