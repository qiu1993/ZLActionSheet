//
//  ZLActionSheetDelegate.swift
//  KKSheet
//
//  Created by Long on 2018/4/3.
//  Copyright © 2018年 xincheng. All rights reserved.
//

import Foundation

@objc public protocol ZLActionSheetDelegate {
   @objc optional func actionSheet(_ actionSheet: ZLActionSheet, clickedButtonAt index: Int)
}
