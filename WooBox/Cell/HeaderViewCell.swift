//
//  HeaderViewCell.swift

import UIKit

class HeaderViewCell: UITableViewCell {

    @IBOutlet weak var imgSideIcon: UIImageView!
    
    @IBOutlet weak var btnRightArrow: UIButton!
//    @IBOutlet weak var btnHeader: UIButton!
    @IBOutlet weak var lblSideText: UILabel!
    
    @IBOutlet weak var vwHeader: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
