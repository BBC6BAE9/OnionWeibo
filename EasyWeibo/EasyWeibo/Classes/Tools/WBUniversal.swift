//
//  WBUniversal.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/20.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

/*
 
 在此作全局常量配置
 
 */
import Foundation
//MARK: 全局通知定义
//定义全局App信息

let WBAppKey = "2694804830"
let WBAppSecret = "2fee1f2bf5be6329afaa4def4f5af456"
let WBRedirectURI = "http://www.baidu.com"

/// 用户需要登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"


let WBUserLoginSuccessedNotificaton = "WBUserLoginSuccessedNotificaton"

//MARK: 微博图片视图常量

//内部外部的间距
let WBStatusPictureViewOutterMargin: CGFloat = 12
//内部图片间的间距
let WBStatusPictureViewInnerMargin: CGFloat = 3

//picView的宽度
let WBStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2*WBStatusPictureViewOutterMargin
//每个item默认的宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth-2*WBStatusPictureViewInnerMargin)/3







//----------------------------------------
import UIKit

enum YMTopicType: Int {
    /// 精选
    case Selection = 4
    /// 美食
    case Food = 14
    /// 家居
    case Household = 16
    /// 数码
    case Digital = 17
    /// 美物
    case GoodThing = 13
    /// 杂货
    case Grocery = 22
}

enum YMShareButtonType: Int {
    /// 微信朋友圈
    case WeChatTimeline = 0
    /// 微信好友
    case WeChatSession = 1
    /// 微博
    case Weibo = 2
    /// QQ 空间
    case QZone = 3
    /// QQ 好友
    case QQFriends = 4
    /// 复制链接
    case CopyLink = 5
}

enum YMOtherLoginButtonType: Int {
    /// 微博
    case weiboLogin = 100
    /// 微信
    case weChatLogin = 101
    /// QQ
    case QQLogin = 102
}

/// 服务器地址
let BASE_URL = "http://api.dantangapp.com/"

/// 第一次启动
let YMFirstLaunch = "firstLaunch"
/// 是否登录
let isLogin = "isLogin"

/// code 码 200 操作成功
let RETURN_OK = 200
/// 间距
let kMargin: CGFloat = 10.0
/// 圆角
let kCornerRadius: CGFloat = 5.0
/// 线宽
let klineWidth: CGFloat = 1.0
/// 首页顶部标签指示条的高度
let kIndicatorViewH: CGFloat = 2.0
/// 新特性界面图片数量
let kNewFeatureCount = 4
/// 顶部标题的高度
let kTitlesViewH: CGFloat = 35
/// 顶部标题的y
let kTitlesViewY: CGFloat = 64
/// 动画时长
let kAnimationDuration = 0.25
/// 屏幕的宽
let SCREENW = UIScreen.main.bounds.size.width
/// 屏幕的高
let SCREENH = UIScreen.main.bounds.size.height
/// 分类界面 顶部 item 的高
let kitemH: CGFloat = 75
/// 分类界面 顶部 item 的宽
let kitemW: CGFloat = 150
/// 我的界面头部图像的高度
let kYMMineHeaderImageHeight: CGFloat = 200
// 分享按钮背景高度
let kTopViewH: CGFloat = 230


/// RGBA的颜色设置
func UNColor(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

/// 背景灰色
func YMGlobalColor() -> UIColor {
    return UNColor(r: 240, g: 240, b: 240, a: 1)
}

/// 红色
func YMGlobalRedColor() -> UIColor {
    return UNColor(r: 184, g: 43, b: 39, a: 1.0)
}

/// iPhone 5
let isIPhone5 = SCREENH == 568 ? true : false
/// iPhone 6
let isIPhone6 = SCREENH == 667 ? true : false
/// iPhone 6P
let isIPhone6P = SCREENH == 736 ? true : false






