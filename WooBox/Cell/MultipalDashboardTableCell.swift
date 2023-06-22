//
//  MultipalDashboardTableCell.swift
//  WooBox
//
//  Created by Goldenmace-E41 on 24/02/20.
//  Copyright © 2020 Goldenmace. All rights reserved.
//

import UIKit

class MultipalDashboardTableCell: UITableViewCell {

    @IBOutlet weak var lblDashboardName: UILabel!
    
    @IBOutlet weak var btnSelectDashboard: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
