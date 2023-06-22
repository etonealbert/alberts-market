//
//  ContactUsTableViewCell.swift

import UIKit

class ContactUsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblKey: UILabel!
    
    @IBOutlet weak var lblValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
