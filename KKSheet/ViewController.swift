//
//  ViewController.swift
//  ZLActionSheet
//
//  Created by long on 2017/10/2.
//  Copyright © 2017年 long. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func button0Handler(_ sender: Any) {
        let mainText = ["确定"]
        let subText = [""]
        let headerText = "确定放弃本次修改？"
        let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, isHiddenTipImg: true, isSubHeaderTilte: true, multHeaderTipTitles: nil)
        actionSheet.actionSheetTranslucent = false
        present(actionSheet, animated: false, completion: nil)
        actionSheet.handler = {index in
            print("index = ", index)
        }
    }
    
    @IBAction func button1Handler() {
        let mainText = ["立即升级到VIP会员（18元/月）", "分享超级标签，免费升级到VIP会员", "编辑"]
        let subText = ["可以加入10个超级标签", "每邀请10位朋友注册，即可享受1年VIP服务", ""]
        let headerText = "您的3个超级标签名额已满"
        let headerTexts = ["XXXX文化传媒有限公司", "项目经理"]
        let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, multHeaderTipTitles: headerTexts)
        actionSheet.actionSheetTranslucent = false
        present(actionSheet, animated: false, completion: nil)
        actionSheet.handler = {index in
            print("index = ", index)
        }
    }
    
    @IBAction func button2Handler() {
        let mainText = ["", "查看2月25日具体档期"]
        let subText = ["目前系统仅支持同一天在同一个城市创建档期\n由于2月25日您在北京已经创建档期\n故您无法创建本次档期", ""]
        let headerText = "有冲突了哈哈哈哈哈哈"
        let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, isHiddenTipImg: false, multHeaderTipTitles: nil)
        actionSheet.actionSheetTranslucent = false
        present(actionSheet, animated: false, completion: nil)
        actionSheet.handler = {index in
            print("index = ", index)
        }
    }
    
    @IBAction func button3Handler() {
        let actionSheet = ZLActionSheet(mainTitleLists: ["拍照", "保存", "上传新的啊"])
        actionSheet.delegate = self
        actionSheet.actionSheetTranslucent = false
        present(actionSheet, animated: false, completion: nil)
    }
    
    @IBAction func button4Handler() {
        let actionSheet = ZLActionSheet(mainTitleLists: ["收藏", "保存", "编辑"])
        actionSheet.delegate = self
        actionSheet.translucent = false
        present(actionSheet, animated: false, completion: nil)
    }
    
    @IBAction func button5Handler() {
        let mainText = ["接受该邀约", "拒绝该邀约", "删除该邀约", "不再接受来自该用户的邀约"]
        let subText = ["", "", "", ""]
        let headerText = "这个邀约和你的档期有冲突！"
        let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, isHiddenTipImg: true, multHeaderTipTitles: nil)
        actionSheet.actionSheetTranslucent = false
        actionSheet.handler = {index in
            print("index = ", index)
        }
        present(actionSheet, animated: false, completion: nil)
    }
    
    @IBAction func button6Handler() {
        let mainText = ["收藏", "保存", "编辑", "查看2月25日具体档期"]
        let subText = ["", "", "", ""]
        let  headerTip = ""
        let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerTip, isHiddenTipImg: true, multHeaderTipTitles: nil)
        actionSheet.actionSheetTranslucent = false
        present(actionSheet, animated: false, completion: nil)
        actionSheet.handler = {index in
            print("index = ", index)
        }
        
    }
}

extension ViewController: ZLActionSheetDelegate {
    func actionSheet(_ actionSheet: ZLActionSheet, clickedButtonAt index: Int) {
        print("index = ", index)
    }
}



