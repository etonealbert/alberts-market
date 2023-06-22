//
//  PaymentsTableCell.swift

import UIKit

class PaymentsTableCell: UITableViewCell {

    @IBOutlet weak var vwPayment: UIView!
    
    @IBOutlet weak var btnPayment: UIButton!
    
    @IBOutlet weak var lblPayment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
