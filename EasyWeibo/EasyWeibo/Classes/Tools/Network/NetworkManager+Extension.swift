//
//  NetworkManager+Extension.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/19.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import Foundation

// MARK: - 封装新浪微博的网络请求方法
extension NetworkManager {
    
    /// 加载微博数据字典数组
    ///
    /// - parameter since_id:   返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    /// - parameter max_id:     返回ID小于或等于max_id的微博，默认为0
    /// - parameter completion: 完成回调[list: 微博字典数组/是否成功]
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // Swift 中 Int 可以转换成 AnyObject/ 但是 Int64 不行
        let params = [
            "since_id":since_id,
            "max_id": (max_id > 0) ? (max_id-1): 0
        ]

        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            
            let result = json?["statuses"] as? [[String: AnyObject]]
            
            completion(result, isSuccess)
        }
    }
    
    /// 返回微博的未读数量 - 定时刷新，不需要提示是否失败！
    func unreadCount(completion: @escaping (_ count: Int)->()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let params = ["uid": uid]
        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            
            let dict = json as? [String: AnyObject]
            let count = dict?["status"] as? Int
            
            completion(count ?? 0)
        }
    }
}

// MARK: - 用户信息
extension NetworkManager {
    
    /// 加载当前用户信息 - 用户登录后立即执行
    //FIXME: - 这个地方我记得好像有一个强行解包隐藏的BUG记得修复
    func loadUserInfo(completion: @escaping (_ dict: [String: AnyObject])->()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid": uid]
        
        // 发起网络请求
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            // 完成回调
            completion((json as? [String: AnyObject]) ?? [:])
        }
    }
}
//丰富的用户信息
extension NetworkManager{

    //加载用户信息
    //在用户登录后立即执行
    func loadUserInfo1(completion:@escaping (_ dict:[String:AnyObject])->()){
    
        guard let uid = userAccount.uid else {
            return
        }
        let urlString = "https://api.weibo.com/2/users/show.json"
    let params = ["uid": uid]

        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            
            print(json)
            
            //完成回调
            completion((json as! [String:AnyObject]) )
            
        }
    }
}
// MARK: - OAuth相关方法
extension NetworkManager {
    
    /// 提问：网络请求异步到底应该返回什么？-需要什么返回什么？
    /// 加载 AccessToken
    ///
    /// - parameter code:       授权码
    /// - parameter completion: 完成回调[是否成功]
    /// - parameter completion: 完成回调，是否成功
    func loadAccessToken(code:String!,completion:@escaping (_ isSuccess:Bool)->()){
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        
        // 发起网络请求
        request(method: .POST, URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            
            
            print("\\\\\\\\\\\\\\\\\\\\\\\\\\\\8888888\(isSuccess)")
            
            //直接用字典用 userAccount的属性
            //如果这里使用KVC会直接崩溃，这个地方是类似KVC的方法
            self.userAccount.yy_modelSet(with: json as? [String:AnyObject] ?? [:])
            
            //*******************************************************
            //警告⚠️[这部分代码呢，是因为目前接口无法获取token，先用这段代码完成逻辑，接口通了之后务必删除这段代码]
            self.userAccount.access_token = "2.00o5VeVDCqH4wC4558b2130blgBTyD"
            self.userAccount.uid = "3216118734"
            self.userAccount.expire_in = 111199
            //*******************************************************
            print(self.userAccount)
            //保存用户信息
            self.userAccount.saveAccount()

            self.loadUserInfo(completion: { (dict) in
                print(dict)
                
                //设置昵称和头像地址
                self.userAccount.yy_modelSet(with: dict)

                self.userAccount.saveAccount()
                print(self.userAccount)

                completion(isSuccess)
            })
        }
        
    }
}
