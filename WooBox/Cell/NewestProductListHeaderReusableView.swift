//
//  NewestProductListHeaderReusableView.swift

import UIKit

class NewestProductListHeaderReusableView: UICollectionReusableView {

    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var lblCollection2019: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.lblCollection2019.text = LanguageLocal.myLocalizedString(key: "Collection")
    }
}
