//
//  WBUserAccount.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/20.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

private let accountFile: NSString = "useraccount.json"
class WBUserAccount: NSObject {
    
    /// 访问令牌
    var access_token:String?
    /// 用户代号
    var uid:String?
    /// AccessToken的生命周期【不保存】
    var expire_in: TimeInterval = 0{
        didSet{
            
            expireDate = Date(timeIntervalSinceNow: expire_in)
            
        }
    }
    
    /// 过期日期【用来保存】
    var expireDate: Date?
    
    /// 用户昵称
    var screen_name:String?
    /// 大头像
    var avatar_large:String?
    
    override var description: String{
        
        return yy_modelDescription()
        
    }
    
    
    override init(){
        super.init()
        //1.从磁盘加载保存的文件
        
        guard let path = accountFile.cz_appendDocumentDir(),
              let data = NSData(contentsOfFile: path),
              let dict = try? JSONSerialization.jsonObject(with: data as Data, options: [])as? [String: AnyObject]
            else{
            return
        }
        //2.使用字典设置属性
        yy_modelSet(with: dict ?? [:])
        
        print("从沙盒加载用户信息")
        //3.判断沙盒是否过期
       if expireDate?.compare(Date()) != .orderedDescending//降序
       {
        print("账户过期")
        //清空token
        access_token = nil
        uid = nil
        //删除账户文件
       _ = try? FileManager.default.removeItem(atPath: path)
        
       }
        
        print("账户正常\(self)")
        
        
        
        
        
    }
    /*
     -1.偏好设置【小】
     -2.沙盒- 归档／WRITE（plist或者json）
     -3.数据库【FMDB／CoreData】
     -4.钥匙串（保存密码／二进制数据）【小／自动加密／需要使用框架SSKeyChain】
     */
    func saveAccount(){
        
        //1.模型转字典
        var dict = (self.yy_modelToJSONObject()as? [String:AnyObject]) ?? [:]
        //删除expire_in的值
        dict.removeValue(forKey: "expire_in")
        
        
        // 2.字典序列化->data
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let filePath = accountFile.cz_appendDocumentDir() else{
                return
        }
        
        //3.写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功\(filePath)")
    }
}
