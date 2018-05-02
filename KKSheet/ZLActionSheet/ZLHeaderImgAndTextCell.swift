//
//  ZLHeaderImgAndTextCell.swift
//  KKSheet
//
//  Created by Long on 2018/4/3.
//  Copyright © 2018年 long. All rights reserved.
//

import UIKit

class ZLHeaderImgAndTextCell: UITableViewCell {

    @IBOutlet weak var warningImgView: UIImageView!
    @IBOutlet weak var singleTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        singleTitleLabel.text = ""
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
