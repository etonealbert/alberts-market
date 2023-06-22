//
//  OrderDetailsCollectionCell.swift

import UIKit

class OrderDetailsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemSeller: UILabel!
    @IBOutlet weak var lblTotalItem: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblActualPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
