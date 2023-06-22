//
//  CardsTableViewCell.swift

import UIKit

class CardsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgCard: UIImageView!
    
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var lblplaceHolderName: UILabel!
    
    @IBOutlet weak var btnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
