//
//  BlogCollectionCell.swift

import UIKit

class BlogCollectionCell: UICollectionViewCell {

    @IBOutlet weak var vwBackground: UIView!
    
    @IBOutlet weak var imgBlog: UIImageView!
    
    @IBOutlet weak var lblBlogTitle: UILabel!
    @IBOutlet weak var lblBlogDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        THelper.setShadow(view: self)
        vwBackground.layer.cornerRadius = 10.0
    }

}
