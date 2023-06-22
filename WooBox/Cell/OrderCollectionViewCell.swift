//
//  OrderCollectionViewCell.swift

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblOldProductPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblNewPrice: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
