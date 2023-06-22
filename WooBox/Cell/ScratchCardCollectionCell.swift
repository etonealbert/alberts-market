//
//  ScratchCardCollectionCell.swift

import UIKit
//import ScratchCard

class ScratchCardCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var vwScrachCard: UIView!
    
//    var scratchCard: ScratchUIView!
    
    @IBOutlet weak var imgCoupon: UIImageView!
    @IBOutlet weak var imgMask: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        scratchCard  = ScratchUIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150),Coupon: "Samantha", MaskImage: "woobox", ScratchWidth: CGFloat(40))
//
//        vwScrachCard.addSubview(scratchCard)
    }

}
