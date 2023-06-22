//
//  RecentSearchViewCell.swift

import UIKit
import Cosmos

class RecentSearchViewCell: UICollectionViewCell {

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwProductRatting: CosmosView!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDiscountPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblActualPrice.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        lblActualPrice.attributedText = attributeString
        
        vwMain.layer.cornerRadius = 10
        vwProductRatting.settings.fillMode = .precise
    }

}
