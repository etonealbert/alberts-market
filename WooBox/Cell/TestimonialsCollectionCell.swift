//
//  TestimonialsCollectionCell.swift

import UIKit

class TestimonialsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var vwBackground: UIView!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgUser.layer.cornerRadius = imgUser.frame.height / 2        
    }

}
