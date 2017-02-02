//
//  AppDelegate.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/13.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //App的一些额外额外设置
        setupAdditions()
       
        sleep(2)
        
        window = UIWindow()
        window?.backgroundColor = UIColor.blue
        window?.rootViewController = WBMainViewController()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        return true
    }
    
    private func loadAppInfo(){
        
        // 模拟异步
        DispatchQueue.global().async {
            
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            
            let data = NSData(contentsOf: url!)
            
            //写入磁盘
            
            let docDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            /*因为OC很多东西都改成了结构体，转换成*/
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            
            data?.write(toFile: jsonPath, atomically: true)
            
            print("应用程序加载完毕")
            print(jsonPath)
        }
    }
    
}



extension AppDelegate{


    func setupAdditions(){
    
    //设置SVProgressHUD最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
    
    //设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
 
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.badge,.carPlay,.sound], completionHandler: { (success, error) in
                print("授权" + (success ? "成功" : "失败"))
            })
        } else {
            
            let notificationSetting = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSetting)
            
        }

    }





}
