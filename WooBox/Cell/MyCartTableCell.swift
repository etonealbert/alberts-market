//
//  MyCartTableCell.swift

import UIKit

class MyCartTableCell: UITableViewCell {

    @IBOutlet weak var constrainBtnColorWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOldAmount: UILabel!
    @IBOutlet weak var lblRemove: UILabel!
    @IBOutlet weak var lblCount: UILabel!

    @IBOutlet weak var vwSteeper: UIView!
    @IBOutlet weak var Stepper: UIStepper!
    
    @IBOutlet weak var btnColor: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnColor.layer.cornerRadius = btnColor.frame.height / 2
        btnColor.layer.masksToBounds = true
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblOldAmount.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        lblOldAmount.attributedText = attributeString
                
        self.lblRemove.text = LanguageLocal.myLocalizedString(key: "Remove")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
