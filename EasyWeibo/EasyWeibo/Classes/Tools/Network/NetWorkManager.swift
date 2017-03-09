//
//  NetWorkManager.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/19.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
import AFNetworking

/// Swift 的枚举支持任意数据类型
/// switch / enum 在 OC 中都只是支持整数
enum WBHTTPMethod {
    case GET
    case POST
}

/// 网络管理工具
class NetworkManager: AFHTTPSessionManager {
    
    /// 静态区／常量／闭包
    /// 在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    static let shared: NetworkManager = {
        
        // 实例化对象
        let instance = NetworkManager()
        
        // 设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        // 返回对象
        return instance
    }()
    
    /// 用户账户的懒加载属性
    lazy var userAccount = WBUserAccount()
    
    /// 用户登录标记[计算型属性]
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    /// 专门负责拼接 token 的网络请求方法
    func tokenRequest(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        // 处理 token 字典
        // 0> 判断 token 是否为 nil，为 nil 直接返回，程序执行过程中，一般 token 不会为 nil(过期了耶不是nil)
        guard let token = userAccount.access_token else {
            
            // 发送通知，提示用户登录
            print("没有 token! 需要登录")
            
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: WBUserShouldLoginNotification),object:nil)
            completion(nil, false)
            
            return
        }
        
        // 1> 判断 参数字典是否存在，如果为 nil，应该新建一个字典
        var parameters = parameters
        if parameters == nil {
            // 实例化字典
            parameters = [String: AnyObject]()
        }
        
        // 2> 设置参数字典，代码在此处字典一定有值
        parameters!["access_token"] = token as AnyObject?
        
        // 调用 request 发起真正的网络请求方法
        request(URLString: URLString, parameters: parameters, completion: completion)
    }
    
    /// 封装 AFN 的 GET / POST 请求
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter completion: 完成回调[json(字典／数组), 是否成功]
    func request(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        
        // 成功回调
        let success = { (task: URLSessionDataTask, json: Any?)->() in

            completion(json as AnyObject?, true)
                        
        }
        
        // 失败回调
        let failure = { (task: URLSessionDataTask?, error: Error)->() in
            
            // 针对 403 处理用户 token 过期
            // 对于测试用户(应用程序还没有提交给新浪微博审核)每天的刷新量是有限的！
            // 超出上限，token 会被锁定一段时间
            // 解决办法，新建一个应用程序！
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
                 // 发送通知，提示用户再次登录(本方法不知道被谁调用，谁接收到通知，谁处理！)
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),
                    object: "bad token")
            }
            
            // error 通常比较吓人，例如编号：XXXX，错误原因一堆英文！
            print("网络请求错误 \(error)")
            
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
