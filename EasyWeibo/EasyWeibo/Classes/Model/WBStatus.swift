//
//  WBStatus.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/19.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
import YYModel

/// 微博数据模型
class WBStatus: NSObject {
    
    /// Int 类型，在 64 位的机器是 64 位，在 32 位机器就是 32 位
    /// 如果不写 Int64 在 iPad 2/iPhone 5/5c/4s/4 都无法正常运行
    var id: Int64 = 0
    /// 微博信息内容
    var text: String?
    // 转发数
    var reposts_count:Int = 0
    
    //评论数量
    var comments_count:Int = 0
    
    //点赞数
    var attitudes_count:Int = 0
    /// 微博的用户 - 注意和服务器返回的 KEY 要一致
    var user: WBUser?
    
    /// 被转发的原创微博
    var retweeted_status: WBStatus?
    
    //微博配图模型数字
    var pic_urls :[WBStatusPicture]?
   
    /// 重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
    ///类函数：告诉第三方框架YYModel如果遇到数组类型的属性，数组中存放的对象是什么类
    ///NSArray中保存对象的类型通常是id
    
    /// OC中的泛型是为了兼容Swift，从运行时的角度，仍然不知道数组中存放的额是什么类型的对象
    
    class func modelContainerPropertyGenericClass()->[String:AnyClass]{
    
    return ["pic_urls": WBStatusPicture.self]
    
    }
   
}
