//
//  FAQTableViewCell.swift

import UIKit

class FAQTableViewCell: UITableViewCell {
    

    @IBOutlet weak var lblkey: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var constraintlblValueHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
