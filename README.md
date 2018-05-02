
# ZLActionSheet

### 自定义ActionSheet
工作中应对自身APP的多个弹窗样式的需求，写了一个ActionSheet封装

## 基本样式及使用方法

### 1、样式1
    有header标题 （单行纯文字） + 确认 + 取消
    header 单行文字 16号 常规体
    
    

![001](https://github.com/qiu1993/ZLActionSheet/blob/master/image/001.jpg)


``` swift 
// 有header标题 （单行纯文字） + 确认 + 取消
  // 显示文本
  let mainText = ["确定"]
  let subText = [""]
  let headerText = "确定放弃本次修改？"
  // 初始化设置参数
  let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, isHiddenTipImg: true, isSubHeaderTilte: true, multHeaderTipTitles: nil)
  // 弹窗
  present(actionSheet, animated: false, completion: nil)
  // 点击回调
  actionSheet.handler = { index in
    print("index = ", index)
  }
```

### 2、样式2
    无header标题（单行纯文字）+ 单行文字 + 多列 + 取消
    

![002_01](https://github.com/qiu1993/ZLActionSheet/blob/master/image/002_01.jpg)
![002_02](https://github.com/qiu1993/ZLActionSheet/blob/master/image/002_02.jpg)

``` swift
// 无header标题（单行纯文字）+ 单行文字 + 多列 + 取消
  // 显示文本
  let mainText = ["收藏", "保存", "编辑", "查看2月25日具体档期"]
  let subText = ["", "", "", ""]
  let  headerTip = ""
  // 初始化设置参数
  let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerTip, isHiddenTipImg: true, multHeaderTipTitles: nil)
  // 弹窗
  present(actionSheet, animated: false, completion: nil)
  // 点击回调方法
  actionSheet.handler = { index in
    print("index = ", index)
  }
```
### 3、样式3

副标题 12号字 常规体
主标题 16号字 中粗体

有header标题（单行纯文字） + 多行文字（主副标题） + 多列 + 取消


![003_01](https://github.com/qiu1993/ZLActionSheet/blob/master/image/003_01.jpg)



![003_02](https://github.com/qiu1993/ZLActionSheet/blob/master/image/003_02.jpg)


``` swift
// 有header标题（单行纯文字） + 多行文字（主副标题） + 多列 + 取消
  // 显示文本
  let mainText = ["立即升级到VIP会员（18元/月）", "分享超级标签，免费升级到VIP会员", "编辑"]
  let subText = ["可以加入10个超级标签", "每邀请10位朋友注册，即可享受1年VIP服务", ""]
  let headerText = "您的3个超级标签名额已满"
  let headerTexts = ["XXXX文化传媒有限公司", "项目经理"]
  // 初始化设置参数
  let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, multHeaderTipTitles: headerTexts)
  // 弹窗本体是否半透明 默认false
  actionSheet.actionSheetTranslucent = false
  // 弹窗
  present(actionSheet, animated: false, completion: nil)
  // 点击回调
  actionSheet.handler = {index in
    print("index = ", index)
  }
  
```
### 4、样式4
有header标题（单行纯文字 + 图片） + 多行文字（多行+多色） + 多列 + 取消



![004](https://github.com/qiu1993/ZLActionSheet/blob/master/image/004.jpg)


``` swift
// 有header标题（单行纯文字 + 图片） + 多行文字（多行+多色） + 多列 + 取消
  // 显示文本
  let mainText = ["", "查看2月25日具体档期"]
  let subText = ["目前系统仅支持同一天在同一个城市创建档期\n由于2月25日您在北京已经创建档期\n故您无法创建本次档期", ""]
  let headerText = "有冲突了哈哈哈哈哈哈"
  // 初始化设置参数
  let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, isHiddenTipImg: false, multHeaderTipTitles: nil)
  // 弹窗本体是否半透明 默认false
  actionSheet.actionSheetTranslucent = false
  // 弹窗
  present(actionSheet, animated: false, completion: nil)
  // 点击回调
  actionSheet.handler = {index in
    print("index = ", index)
  }
```
### 5、样式5
有header标题（单行纯文字 + 图片）+ 单行文字 + 多列 + 取消



![005](https://github.com/qiu1993/ZLActionSheet/blob/master/image/005.jpg)


``` swift
// 有header标题（单行纯文字 + 图片）+ 单行文字 + 多列 + 取消
  // 显示文本
  let mainText = ["接受该邀约", "拒绝该邀约", "删除该邀约", "不再接受来自该用户的邀约"]
  let subText = ["", "", "", ""]
  let headerText = "这个邀约和你的档期有冲突！"
  // 初始化设置参数
  let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, isHiddenTipImg: true, multHeaderTipTitles: nil)
  // 弹窗本体是否半透明 默认false
  actionSheet.actionSheetTranslucent = false
  // 弹窗
  present(actionSheet, animated: false, completion: nil)
  // 点击回调
  actionSheet.handler = { index in
    print("index = ", index)
  }
  
```
### 6、样式6
有header标题（多行纯文字）+ 单行+单列 + 取消

![006_01](https://github.com/qiu1993/ZLActionSheet/blob/master/image/006_01.jpg)
![006_02](https://github.com/qiu1993/ZLActionSheet/blob/master/image/006_02.jpg)
![006_03](https://github.com/qiu1993/ZLActionSheet/blob/master/image/006_03.jpg)

``` swift
// 有header标题（单行纯文字） + 多行文字（主副标题） + 多列 + 取消
  // 显示文本
  let mainText = ["立即升级到VIP会员（18元/月）", "分享超级标签，免费升级到VIP会员", "编辑"]
  let subText = ["可以加入10个超级标签", "每邀请10位朋友注册，即可享受1年VIP服务", ""]
  let headerText = "您的3个超级标签名额已满"
  let headerTexts = ["XXXX文化传媒有限公司", "项目经理"]
  // 初始化设置参数
  let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, multHeaderTipTitles: headerTexts)
  // 弹窗本体是否半透明 默认false
  actionSheet.actionSheetTranslucent = false
  // 弹窗
  present(actionSheet, animated: false, completion: nil)
  // 点击回调
  actionSheet.handler = {index in
    print("index = ", index)
  }
  
```

## Delegate 
点击按钮的事件可以通过两种方法获取；

* #### 1、设置Delegate，遵守ZLActionSheetDelegate代理方法

``` swift
extension ViewController: ZLActionSheetDelegate {
    func actionSheet(_ actionSheet: ZLActionSheet, clickedButtonAt index: Int) {
        print("index = ", index)
    }
}
```
* #### 2、直接使用handler block回调

``` swift
actionSheet.handler = { index in
            print("index = ", index)
}
```
## init

``` swift
/** 
init parameter. 
- parameter hasCancelBtn: 是否有底部取消按钮. 
- parameter mainTitleLists: 选项的主标题数组. 
- parameter subTitleLists: 选项的副标题数组. 
- parameter headerTipTitle: 顶部header文字. 
- parameter isHiddenTipImg: 是否有顶部header提示图标. 
- parameter isSubHeaderTilte: 顶部header文字是否是副标题样式.
- parameter multHeaderTipTitles: 顶部header是否是多行文字样式.
*/ 

// 有header标题 （单行纯文字） + 确认 + 取消
  // 显示文本
  let mainText = ["确定"]
  let subText = [""]
  let headerText = "确定放弃本次修改？"
  // 初始化设置参数
  let actionSheet = ZLActionSheet(hasCancelBtn: true, mainTitleLists: mainText, subTitleLists: subText, headerTipTitle: headerText, isHiddenTipImg: true, isSubHeaderTilte: true, multHeaderTipTitles: nil)
  // 弹窗
  present(actionSheet, animated: false, completion: nil)
  // 点击回调
  actionSheet.handler = { index in
    print("index = ", index)
  }
```
