//
//  ReviewHeaderViewCell.swift

import UIKit

class ReviewHeaderViewCell: UITableViewCell {

    @IBOutlet weak var vwReviewStar: UIView!
    @IBOutlet weak var btnRateView: UIButton!
    @IBOutlet weak var imgStar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if IPAD {
            self.vwReviewStar.layer.cornerRadius = 150 / 2
            
        }else {
            self.vwReviewStar.layer.cornerRadius = self.vwReviewStar.frame.size.height / 2
            
        }
        THelper.setTintColor(imgStar, tintColor: UIColor.yellow)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected stat
    }
    
}
