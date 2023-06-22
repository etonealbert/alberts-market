//
//  SizeViewCell.swift

import UIKit

class SizeViewCell: UICollectionViewCell {

    @IBOutlet weak var vwSize: UIView!
    @IBOutlet weak var lblSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwSize.layer.cornerRadius = vwSize.frame.height / 2
    }

}
