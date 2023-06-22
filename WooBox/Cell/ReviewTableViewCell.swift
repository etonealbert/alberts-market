//
//  ReviewTableViewCell.swift

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var vwStar: UIView!
        
    @IBOutlet weak var vwRating: UIView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblReviewerName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var btnRating: UIButton!
    @IBOutlet weak var btnEditDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.SetUpObject()
    }
    
    func SetUpObject() {
        if IPAD {
            self.vwStar.layer.cornerRadius = 20.0
        }else {
            self.vwStar.layer.cornerRadius = 15.0
        }
        self.btnRating = THelper.setButtonTintColor(self.btnRating, imageName: "icoStar", state: .normal, tintColor: ThemeManager.shared()?.color(forKey: "color5"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
