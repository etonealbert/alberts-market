//
//  OrderSummaryProductTableCell.swift

import UIKit

class OrderSummaryProductTableCell: UITableViewCell {

    @IBOutlet weak var constrainBtnColorWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblQuentity: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOldAmount: UILabel!
    
    @IBOutlet weak var btnColor: UIButton!
    @IBOutlet weak var btnQuentity: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnColor.layer.cornerRadius = btnColor.frame.height / 2
        btnColor.layer.masksToBounds = true
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblOldAmount.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        lblOldAmount.attributedText = attributeString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
