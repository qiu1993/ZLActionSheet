//
//  ZLMultiTitleLabelCell.swift
//  KKSheet
//
//  Created by Long on 2018/4/3.
//  Copyright © 2018年 long. All rights reserved.
//

import UIKit

class ZLMultiTitleLabelCell: UITableViewCell {
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainTitleLabel.text = ""
        subTitleLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

let kPingFangThin = "PingFangSC-Thin"
let kPingFangLight = "PingFangSC-Light"
let kPingFangMedium = "PingFangSC-Medium"
let kPingFangRegular = "PingFangSC-Regular"
let kPingFangSemibold = "PingFangSC-Semibold"
let kPingFangBold = "PingFangSC-Bold"

extension UIFont {
    static func pingFang(_ size: CGFloat, _ weight: UIFont.Weight) -> UIFont {
        var fontName: String
        switch weight {
        case Weight.light:
            fontName = kPingFangLight
        case Weight.regular:
            fontName = kPingFangRegular
        case Weight.semibold:
            fontName = kPingFangSemibold
        case Weight.bold:
            fontName = kPingFangBold
        default:
            fontName = ""
        }
        return UIFont(name: fontName, size: size)!
    }
}

