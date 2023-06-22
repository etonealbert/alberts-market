//
//  BrandsTableCell.swift

import UIKit

class BrandsTableCell: UITableViewCell {

    @IBOutlet weak var lblBrands: UILabel!
    
    @IBOutlet weak var btnSelectBrand: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSelectBrand.layer.cornerRadius = 5
        btnSelectBrand.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
