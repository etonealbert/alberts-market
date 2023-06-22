//
//  DiscountTableCell.swift

import UIKit

class DiscountTableCell: UITableViewCell {

    @IBOutlet weak var btnSelectDiscount: UIButton!
    
    @IBOutlet weak var lblDiscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSelectDiscount.layer.cornerRadius = 5
        btnSelectDiscount.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
