//
//  DelivereCollectionViewCell.swift

import UIKit

class DelivereCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblOldProductPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblNewPrice: UILabel!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
