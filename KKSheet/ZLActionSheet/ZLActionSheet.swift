//
//  ZLActionSheet.swift
//  KKSheet
//
//  Created by Long on 2018/4/3.
//  Copyright © 2018年 xincheng. All rights reserved.
//

import Foundation
import UIKit

public typealias handlerAction = (Int)->()
public class ZLActionSheet: UIViewController {
    // MARK: - public property
    public var handler: handlerAction?
    public var delegate: ZLActionSheetDelegate?
    public var textColor: UIColor?
    public var textFont: UIFont?
    public var cancelTextColor: UIColor?
    public var cancelTextFont: UIFont?
    public var actionSheetTitle: String?
    public var actionSheetTitleFont: UIFont?
    public var actionSheetTitleColor: UIColor?
    public var headerTitle: String?
    
    /// 为了更好的融合到当前视图中，弹出框默认alpha是0.7，默认是true，如果你不想要半透明，可以设置为false
    public var actionSheetTranslucent: Bool = true {
        didSet {
            if !actionSheetTranslucent {
                self.tableView.alpha = 1.0
            }
        }
    }
    
    /// 弹出后，背景是半透明，默认是true，设置为false，则去掉半透明
    public var translucent: Bool = true {
        didSet{
            if !translucent {
                self.overlayView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0)
            }
        }
    }
    
    // MARK: - private property
    fileprivate let hasCancelButton: Bool
    fileprivate let hiddenHeaderImg: Bool
    fileprivate let screenWidth = UIScreen.main.bounds.size.width
    fileprivate let screenHeight = UIScreen.main.bounds.size.height
    fileprivate let mainTitleLists: [String]!
    fileprivate let subTitleLists: [String]?
    fileprivate let multHeaderTitles: [String]?
    fileprivate var overlayView: UIView!
    fileprivate var tableView: UITableView!
    fileprivate let gapHeight: CGFloat = 5
    fileprivate let overlayBackgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.5)
    fileprivate let multiTitleRf = "multiTitleCell"
    fileprivate let headerImgAndTextRf = "headerImgAndTextCell"
    fileprivate let multiTitleHeaderRf = "multiHeaderTitleCell"

    // MARK: - system cycle
    required public init(hasCancelBtn: Bool = false, mainTitleLists: [String]!) {
        self.mainTitleLists = mainTitleLists
        self.subTitleLists = nil
        self.hasCancelButton = hasCancelBtn
        self.hiddenHeaderImg = true
        self.multHeaderTitles = nil
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.clear
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        setup()
    }

    required public init(hasCancelBtn: Bool = false, mainTitleLists: [String]!, subTitleLists: [String]?, headerTipTitle: String = "", isHiddenTipImg: Bool = true, multHeaderTipTitles: [String]?) {
        self.headerTitle = headerTipTitle
        self.mainTitleLists = mainTitleLists
        self.subTitleLists = subTitleLists
        self.hasCancelButton = hasCancelBtn
        self.hiddenHeaderImg = isHiddenTipImg
        self.multHeaderTitles = multHeaderTipTitles
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.clear
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        setup()
    }
   
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var height: CGFloat = 50
        var autoHeight: CGFloat = 0
        var autoSubHeight: CGFloat = 0

        for item in self.mainTitleLists {
            var itemH = item.getTextHeightWithMaxH(fontSize: 16, width: 15, maxHeight: 50)
            if itemH == 50 && item.contains("\n") {
                itemH = 65
            } else {
               itemH = 50
            }
           autoHeight += itemH
        }
        if self.subTitleLists != nil {
            for item in self.subTitleLists! {
                var itemH = item.getTextHeightWithMaxH(fontSize: 16, width: 15, maxHeight: 50)
                if itemH == 50 && item.contains("\n") {
                    itemH = 65
                } else {
                    itemH = 50
                }
                autoSubHeight += itemH
            }
        }
        let useHeight = autoHeight > autoSubHeight ? autoHeight : autoSubHeight
        print(useHeight)
        var indexNum: CGFloat = 0.0  // 头和尾个数

        if hasImgAndTextHeader() {
            if hasCancelButton {
                if hasMultTextHeader() {
                   indexNum = 3.4
                } else {
                   indexNum = 2
                }
            } else {
               indexNum = 1
            }
        } else {
            if hasCancelButton {
                indexNum = 1
            } else {
                indexNum = 0
            }
        }
        if mainTitleLists != nil && mainTitleLists.count != 0 {
            if hasCancelButton {
                height = useHeight + CGFloat(indexNum) * height + gapHeight
            }else {
                height = useHeight + CGFloat(indexNum) * height
            }
        } else {
            if hasCancelButton {
                height = CGFloat(indexNum) * height + gapHeight
            }else {
                height = CGFloat(indexNum) * height
            }
        }
        var bottom: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottom = self.view.safeAreaInsets.bottom
        }
        let frame = CGRect(x: 0, y: screenHeight - height - bottom, width: screenWidth, height: height + bottom)
        UIView.animate(withDuration: 0.2) {
            self.tableView.frame = frame
            self.overlayView.alpha = 1.0
        }
    }
    
    //MARK: - private method
    fileprivate func setup() {
        overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = overlayBackgroundColor
        overlayView.alpha = 0
        self.view.addSubview(overlayView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(overlayViewTapHandler))
        overlayView.addGestureRecognizer(tap)
        
        var frame = self.view.frame
        frame.origin.y = self.screenHeight
        tableView = UITableView(frame: frame, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alpha = 0.7
        tableView.register(UINib(nibName: "ZLMultiTitleLabelCell", bundle: nil), forCellReuseIdentifier: multiTitleRf)
        tableView.register(UINib(nibName: "ZLHeaderImgAndTextCell", bundle: nil), forCellReuseIdentifier: headerImgAndTextRf)
        tableView.register(UINib(nibName: "ZLMultTitleiHeaderCell", bundle: nil), forCellReuseIdentifier: multiTitleHeaderRf)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        view.bringSubview(toFront: tableView)
    }
    
    @objc fileprivate func overlayViewTapHandler() {
        UIView.animate(withDuration: 0.2, animations: {
            var frame = self.tableView.frame
            frame.origin.y = self.view.bounds.size.height
            self.tableView.frame = frame
            self.overlayView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc fileprivate func deviceOrientationDidChange() {
        let height = self.tableView.bounds.size.height
        let width = self.view.bounds.size.width
        let y = self.view.bounds.size.height - height
        let frame = CGRect(x: 0, y: y, width: width, height: height)
        UIView.animate(withDuration: 0.2) {
            self.overlayView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2));
            self.tableView.frame = frame
            self.overlayView.frame = self.view.bounds
        }
    }
}

extension ZLActionSheet {
    // 是否有 headerTitle
    fileprivate func hasImgAndTextHeader() -> Bool {
        return self.headerTitle != nil && self.headerTitle!.count != 0
    }
    // 是否有 多行的headerTitle
    fileprivate func hasMultTextHeader() -> Bool {
        return multHeaderTitles != nil && multHeaderTitles!.count != 0
    }
    // 是否有 主文本
    fileprivate func hasButtonList() -> Bool {
        return mainTitleLists != nil && mainTitleLists.count != 0
    }
    // 是否有 副标题文本
    fileprivate func hasSubButtonList() -> Bool {
        return subTitleLists != nil && subTitleLists!.count != 0
    }
    
    fileprivate func setCancelButtonTextColorAndTextFont(cell: ZLMultiTitleLabelCell) {
        if cancelTextColor != nil {
            cell.mainTitleLabel.textColor = cancelTextColor
        }else {
            cell.mainTitleLabel.textColor = UIColor.black
        }
        if cancelTextFont != nil {
            cell.mainTitleLabel.font = cancelTextFont
        }else {
            cell.mainTitleLabel.font = UIFont.pingFang(16, .regular)
        }
    }
    
    fileprivate func setTextButtonTextColorAndTextFont(cell: ZLMultiTitleLabelCell) {
        if textColor != nil {
            cell.mainTitleLabel.textColor = textColor
        }else {
            cell.mainTitleLabel.textColor = UIColor.black
        }
        if textFont != nil {
            cell.mainTitleLabel.font = textFont
        }else {
            cell.mainTitleLabel.font = UIFont.pingFang(16, .regular)
        }
    }
    
    fileprivate func setTitleColorAndTextFont(cell: ZLMultiTitleLabelCell) {
        if actionSheetTitleFont != nil {
            cell.mainTitleLabel.font = actionSheetTitleFont
        }else {
            cell.mainTitleLabel.font = UIFont.pingFang(16, .regular)
        }
        if actionSheetTitleColor != nil {
            cell.mainTitleLabel.textColor = actionSheetTitleColor
        }else {
            cell.mainTitleLabel.textColor = UIColor.darkGray
        }
    }
}

extension ZLActionSheet: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if hasImgAndTextHeader() {
            if hasCancelButton {
                return 3
            } else {
                return 2
            }
        } else {
            if hasCancelButton {
                return 3
            } else {
                return 2
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasImgAndTextHeader() {
            if hasCancelButton {
                switch section {
                case 0:
                    return 1
                case 1:
                    return mainTitleLists.count
                default:
                    return 1
                }
            } else {
                switch section {
                case 0:
                    return 1
                case 1:
                    return mainTitleLists.count
                default:
                    return 0
                }
            }
        } else {
            if hasCancelButton {
                switch section {
                case 0:
                    return 0
                case 1:
                    return mainTitleLists.count
                default:
                    return 1
                }
            } else {
                switch section {
                case 0:
                    return 0
                case 1:
                    return mainTitleLists.count
                default:
                    return 0
                }
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 有headerTitle
        if hasImgAndTextHeader() {
             // 有取消按钮
            if hasCancelButton {
                switch indexPath.section {
                case 0:
                    if hasMultTextHeader() {
                        let cell: ZLMultTitleiHeaderCell = tableView.dequeueReusableCell(withIdentifier: multiTitleHeaderRf, for: indexPath) as! ZLMultTitleiHeaderCell
                        cell.bottomMainTitleLabel.text = self.multHeaderTitles?[0]
                        cell.bottomSubTitleLabel.text = self.multHeaderTitles?[1]
                        return cell
                    } else {
                        let cell: ZLHeaderImgAndTextCell = tableView.dequeueReusableCell(withIdentifier: headerImgAndTextRf, for: indexPath) as! ZLHeaderImgAndTextCell
                        cell.singleTitleLabel.text = self.headerTitle
                        cell.warningImgView.isHidden = self.hiddenHeaderImg
                        return cell
                    }
                    
                default:
                    let cell: ZLMultiTitleLabelCell = tableView.dequeueReusableCell(withIdentifier: multiTitleRf, for: indexPath) as! ZLMultiTitleLabelCell
                    if indexPath.section == 2 {
                        cell.mainTitleLabel.text = "取消"
                        self.setCancelButtonTextColorAndTextFont(cell: cell)
                    } else {
                        cell.mainTitleLabel.text = mainTitleLists[indexPath.row]
                        cell.subTitleLabel.text = subTitleLists?[indexPath.row]
                        self.setTextButtonTextColorAndTextFont(cell: cell)
                    }
                    return cell
               }
            } else {
                // 无取消按钮
                switch indexPath.section {
                case 0:
                    if hasMultTextHeader() {
                        let cell: ZLMultTitleiHeaderCell = tableView.dequeueReusableCell(withIdentifier: multiTitleHeaderRf, for: indexPath) as! ZLMultTitleiHeaderCell
                        cell.bottomMainTitleLabel.text = self.multHeaderTitles?[0]
                        cell.bottomSubTitleLabel.text = self.multHeaderTitles?[1]
                        return cell
                    } else {
                        let cell: ZLHeaderImgAndTextCell = tableView.dequeueReusableCell(withIdentifier: headerImgAndTextRf, for: indexPath) as! ZLHeaderImgAndTextCell
                        cell.singleTitleLabel.text = self.headerTitle
                        cell.warningImgView.isHidden = self.hiddenHeaderImg
                        return cell
                    }
                default:
                    let cell: ZLMultiTitleLabelCell = tableView.dequeueReusableCell(withIdentifier: multiTitleRf, for: indexPath) as! ZLMultiTitleLabelCell
                    cell.mainTitleLabel.text = mainTitleLists[indexPath.row]
                    cell.subTitleLabel.text = subTitleLists?[indexPath.row]
                    self.setTextButtonTextColorAndTextFont(cell: cell)
                    return cell
                }
            }
        } else {
        // 无headerTitle
            // 有取消按钮
            if hasCancelButton {
                switch indexPath.section {
                case 0:
                    if hasMultTextHeader() {
                        let cell: ZLMultTitleiHeaderCell = tableView.dequeueReusableCell(withIdentifier: multiTitleHeaderRf, for: indexPath) as! ZLMultTitleiHeaderCell
                        cell.bottomMainTitleLabel.text = self.multHeaderTitles?[0]
                        cell.bottomSubTitleLabel.text = self.multHeaderTitles?[1]
                        return cell
                    } else {
                        let cell: ZLHeaderImgAndTextCell = tableView.dequeueReusableCell(withIdentifier: headerImgAndTextRf, for: indexPath) as! ZLHeaderImgAndTextCell
                        cell.singleTitleLabel.text = self.headerTitle
                        cell.warningImgView.isHidden = self.hiddenHeaderImg
                        return cell
                    }
                default:
                    let cell: ZLMultiTitleLabelCell = tableView.dequeueReusableCell(withIdentifier: multiTitleRf, for: indexPath) as! ZLMultiTitleLabelCell
                    
                    if indexPath.section == 2 {
                        cell.mainTitleLabel.text = "取消"
                        self.setCancelButtonTextColorAndTextFont(cell: cell)
                    } else {
                        cell.mainTitleLabel.text = mainTitleLists[indexPath.row]
                        cell.subTitleLabel.text = subTitleLists?[indexPath.row]
                        self.setTextButtonTextColorAndTextFont(cell: cell)
                    }
                    return cell
                }
            } else {
                // 无取消按钮
                let cell: ZLMultiTitleLabelCell = tableView.dequeueReusableCell(withIdentifier: multiTitleRf, for: indexPath) as! ZLMultiTitleLabelCell
                cell.mainTitleLabel.text = mainTitleLists[indexPath.row]
                cell.subTitleLabel.text = subTitleLists?[indexPath.row]
                self.setTextButtonTextColorAndTextFont(cell: cell)
                return cell
            }
        }
    }
    
}

extension ZLActionSheet: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 有headerTitle
        if hasImgAndTextHeader() {
            // 有取消按钮
            if hasCancelButton {
                switch indexPath.section {
                case 0:
                    return
                case 1:
                    if handler != nil {
                        handler!(indexPath.row)
                    }
                    if (delegate != nil) {
                        self.delegate?.actionSheet!(self, clickedButtonAt: indexPath.row)
                    }
                    self.overlayViewTapHandler()
                default:
                    self.overlayViewTapHandler()
                    return
                }
            } else {
                // 无取消按钮
                switch indexPath.section {
                case 0:
                    return
                case 1:
                    if handler != nil {
                        handler!(indexPath.row)
                    }
                    if (delegate != nil) {
                        self.delegate?.actionSheet!(self, clickedButtonAt: indexPath.row)
                    }
                    self.overlayViewTapHandler()
                default:
                    return
                }
            }
        } else {
            // 无headerTitle
            // 有取消按钮
            if hasCancelButton {
                switch indexPath.section {
                case 0:
                    self.overlayViewTapHandler()
                    return
                case 1:
                    if handler != nil {
                        handler!(indexPath.row)
                    }
                    if (delegate != nil) {
                        self.delegate?.actionSheet!(self, clickedButtonAt: indexPath.row)
                    }
                    self.overlayViewTapHandler()
                default:
                    self.overlayViewTapHandler()
                    return
                }
            } else {
                // 无取消按钮
                if handler != nil {
                    handler!(indexPath.row)
                }
                if (delegate != nil) {
                    self.delegate?.actionSheet!(self, clickedButtonAt: indexPath.row)
                }
                self.overlayViewTapHandler()
            }
        }
        
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let reuseIdentifier = "header"
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)
        if (view == nil) {
            view = UITableViewHeaderFooterView(reuseIdentifier: reuseIdentifier)
            view?.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        }
        return view
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if hasImgAndTextHeader() {
            if hasCancelButton {
                switch indexPath.section {
                case 0:
                    if hasMultTextHeader() {
                        return 120
                    } else {
                        return 50
                    }
                case 1:
                    let cellTextHeight = self.mainTitleLists[indexPath.row].getTextHeightWithMaxH(fontSize: 16, width: 15, maxHeight: 50)
                    let subTextHeight = self.mainTitleLists[indexPath.row].getTextHeightWithMaxH(fontSize: 12, width: 15, maxHeight: 50)
                    var subTitle = ""
                    if self.subTitleLists != nil {
                        subTitle = self.subTitleLists![indexPath.row]
                    }
                    if (cellTextHeight == 50 || subTextHeight == 50) && (self.mainTitleLists[indexPath.row].contains("\n") || subTitle.contains("\n")) {
                        return 65
                    } else {
                        return 50
                    }
                default:
                    return 50
                }
            } else {
                switch indexPath.section {
                case 0:
                    if hasMultTextHeader() {
                        return 120
                    } else {
                        return 50
                    }
                case 1:
                    let cellTextHeight = self.mainTitleLists[indexPath.row].getTextHeightWithMaxH(fontSize: 16, width: 15, maxHeight: 50)
                    let subTextHeight = self.mainTitleLists[indexPath.row].getTextHeightWithMaxH(fontSize: 12, width: 15, maxHeight: 50)
                    var subTitle = ""
                    if self.subTitleLists != nil {
                        subTitle = self.subTitleLists![indexPath.row]
                    }
                    if (cellTextHeight == 50 || subTextHeight == 50) && (self.mainTitleLists[indexPath.row].contains("\n") || subTitle.contains("\n")) {
                        return 65
                    } else {
                        return 50
                    }
                default:
                    return 0
                }
            }
        } else {
            if hasCancelButton {
                switch indexPath.section {
                case 0:
                    return 0
                case 1:
                    let cellTextHeight = self.mainTitleLists[indexPath.row].getTextHeightWithMaxH(fontSize: 16, width: 15, maxHeight: 50)
                    let subTextHeight = self.mainTitleLists[indexPath.row].getTextHeightWithMaxH(fontSize: 12, width: 15, maxHeight: 50)
                    var subTitle = ""
                    if self.subTitleLists != nil {
                        subTitle = self.subTitleLists![indexPath.row]
                    }
                    if (cellTextHeight == 50 || subTextHeight == 50) && (self.mainTitleLists[indexPath.row].contains("\n") || subTitle.contains("\n")) {
                        return 65
                    } else {
                        return 50
                    }
                default:
                    return 50
                }
            } else {
                switch indexPath.section {
                case 0:
                    return 0
                case 1:
                    let cellTextHeight = self.mainTitleLists[indexPath.row].getTextHeightWithMaxH(fontSize: 16, width: 15, maxHeight: 50)
                    let subTextHeight = self.mainTitleLists[indexPath.row].getTextHeightWithMaxH(fontSize: 12, width: 15, maxHeight: 50)
                    var subTitle = ""
                    if self.subTitleLists != nil {
                        subTitle = self.subTitleLists![indexPath.row]
                    }
                    if (cellTextHeight == 50 || subTextHeight == 50) && self.mainTitleLists[indexPath.row].contains("\n") || subTitle.contains("\n") {
                        return 65
                    } else {
                        return 50
                    }
                default:
                    return 0
                }
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if hasImgAndTextHeader() {
            if hasCancelButton {
                switch section {
                case 0:
                    return 0.01
                case 1:
                    return 1.5
                default:
                    return 5
                }
            } else {
                switch section {
                case 0:
                    return 0.01
                case 1:
                    return 1.5
                default:
                    return 0.01
                }
            }
        } else {
            if hasCancelButton {
                switch section {
                case 0:
                    return 0.01
                case 1:
                    return 0.01
                default:
                    return 5
                }
            } else {
                switch section {
                case 0:
                    return 0.01
                default:
                    return 0.01
                }
            }
        }
    }
}

// 计算文字高度或者宽度与weight参数无关
extension String {
    // 获取文本宽度
    func getTextWidth(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attribute: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : font]
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return ceil(rect.width)
    }
    // 获取文本高度
    func getTextHeight(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attribute: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : font]
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return ceil(rect.height)
    }
    // 获取文本高度 有最大值
    func getTextHeightWithMaxH(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attribute: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : font]
        if self != "" && self.count != 0 {
            let options = NSStringDrawingOptions(rawValue:    NSStringDrawingOptions.usesFontLeading.rawValue |    NSStringDrawingOptions.usesLineFragmentOrigin.rawValue |
                NSStringDrawingOptions.truncatesLastVisibleLine.rawValue
            )
            let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: options, attributes: attribute, context: nil)
            return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
        } else {
            return 50
        }
    }
}

