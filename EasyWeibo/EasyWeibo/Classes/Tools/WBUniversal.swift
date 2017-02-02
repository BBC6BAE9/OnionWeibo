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

let WBAppKey = "2850289738"
let WBAppSecret = "bf21cf4462eb5b47c88191a50da26b07"
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
