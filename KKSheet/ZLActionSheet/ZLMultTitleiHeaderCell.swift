//
//  ZLMultTitleiHeaderCell.swift
//  KKSheet
//
//  Created by Long on 2018/4/11.
//  Copyright © 2018年 xincheng. All rights reserved.
//

import UIKit

class ZLMultTitleiHeaderCell: UITableViewCell {
    
    @IBOutlet weak var topSubTitleLabel: UILabel!
    @IBOutlet weak var midLineContentView: UIView!
    @IBOutlet weak var bottomMainTitleLabel: UILabel!
    @IBOutlet weak var bottomSubTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomMainTitleLabel.text = ""
        bottomSubTitleLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
