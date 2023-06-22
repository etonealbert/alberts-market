//
//  EmailTableViewCell.swift

import UIKit

class EmailTableViewCell: UITableViewCell {

    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var lblkey: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
