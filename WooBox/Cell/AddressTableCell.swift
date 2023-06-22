//
//  AddressTableCell.swift

import UIKit

class AddressTableCell: UITableViewCell {

    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
