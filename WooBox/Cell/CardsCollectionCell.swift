//
//  CardsCollectionCell.swift

import UIKit

class CardsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgCard: UIImageView!
    
    @IBOutlet weak var lblCardType: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var lblCardHolderName: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }

}
