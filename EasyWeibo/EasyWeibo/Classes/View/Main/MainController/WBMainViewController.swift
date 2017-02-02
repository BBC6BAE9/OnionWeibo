//
//  WBMainViewController.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/13.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
import SVProgressHUD
//主控制器
class WBMainViewController: UITabBarController {
    
    //定时器
    private var timer: Timer?
    
    //私有控件
    private lazy var composeButton:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
        
        setupChildControllers()
        setupComposeButton()
        setupTimer()

        
    //设置新特性
        setupNewFeatures()
        
        
        
        // 设置代理
        delegate = self
       
    }
    
    deinit {
        //销毁时钟
        timer?.invalidate()
        
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func userLogin(n:Notification){
    
        print("用户登录通知\(n)")
        
        var when = DispatchTime.now()
        //判断n.object是否有值，如果有提示用户重新登录
        
        if n.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            
            when = DispatchTime.now() + 2
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.black)

            let nav = UINavigationController(rootViewController: WBOAuthViewController())
            
            self.present(nav, animated: true, completion: nil)
        }
       
        
        
        
    }
    
    
    /**
     哈哈哈单词好形象！！！
     portrait  竖屏（肖像）
     landscape 横屏（风景画）
     
     -使用代码控制可以随时按需横竖屏
     -支持方向之后，控制器和子控制器及其子控制器都会遵守这个方向
     -如果是支持视频的通常通过modal展现的
     
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        
        return .portrait
        
    }
    //保护函数私有，保证KVC调用
    @objc private func composeStatus(){
        
        print("撰写微博")
        
    }
    
    private func setupComposeButton(){
        
        tabBar.addSubview(composeButton)
        //设置按钮的位置
        //计算按钮的宽度
        let count:CGFloat = CGFloat(childViewControllers.count)
        let w = tabBar.bounds.width/count
        //缩进
        composeButton.frame = tabBar.bounds.insetBy(dx: 2*w, dy: 0)
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    private func setupChildControllers(){
        
        //从bundle加载配置的json
        //1.路径
        //2.加载NSData
        //3.反序列化转化成数组
        

        //获取沙盒json路径
        

        let docDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        /*因为OC很多东西都改成了结构体，转换成*/
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        //加载data
        var data = NSData(contentsOfFile: jsonPath)
        
        
        if data == nil {
        
        //从bundle加载data
        
        let path = Bundle.main.path(forResource: "main.json", ofType: nil)

            data = NSData(contentsOfFile: path!)
            
        }
       
        
        
        guard  let array = try? JSONSerialization.jsonObject(with: data as! Data, options:JSONSerialization.ReadingOptions.allowFragments)as? [[String: Any]]
            else{
                
                return
        }
        
        //现在很多的App中界面的加载都跟网络获得的json有关
        //        let arrayXX :[[String:Any]] = [
        //
        //            ["clsName": "WBHomeViewController", "title": "首页", "imageName": "home", "visitorInfo": ["imageName": "","message": "关注一些人回看有什么惊喜" ]],
        //
        //            ["clsName": "WBMessageViewController", "title": "消息", "imageName": "message_center", "visitorInfo": ["imageName": "visitordiscover_image_message","message": "登录后别人评论你的微博，发给你的信息，都会在这里面收藏" ]],
        //
        //            ["clsName": "UIViewController"],
        //
        //            ["clsName": "WBDiscoverViewController","title": "发现","imageName": "discover","visitorInfo": ["imageName": "visitordiscover_image_message", "message": "登录后，最新最热的微博尽在掌握，不会再与时尚潮流擦肩而过" ]],
        //
        //            ["clsName": "WBProfileViewController", "title": "我", "imageName": "profile", "visitorInfo": ["imageName": "visitordiscover_image_profile", "message": "登录后，你的微博相册个人信息会在这里展示"]]
        //
        //        ]
        //测试数据格式是否正确
        //(array as NSArray).write(toFile:"/Users/mac/Desktop/Demo.plist", atomically: true)
        
        //json序列化
        //        let data = try! JSONSerialization.data(withJSONObject: array, options:[.prettyPrinted])
        //
        //        (data as NSData).write(toFile: "/Users/mac/Desktop/Demo.json", atomically: true)
        
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    
    private func controller(dict:[String:Any])->UIViewController{
        
        //1.取得字典内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.nameSpace+"."+clsName)as? WBBaseViewController.Type,
            let visitorDict = dict["visitorInfo"] as? [String:String]
            
            else{
                
                return UIViewController()
                
        }
        
        //2.创建视图控制器
        
        
        
        //系统默认的是12号字
        let vc = cls.init()
        //设置访问控制器的信息字典
        vc.visitorInfoDictionary = visitorDict
        vc.title = title
        let imgName = "tabbar_"+"\(imageName)"
        vc.tabBarItem.image = UIImage(named: imgName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_\(imageName)_selected")?.withRenderingMode(.alwaysOriginal)
        //设置tabbar的标题字体
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont.systemFont(ofSize: 14)],
                                             for: .highlighted)
        
        
        let nav = WBNavigationController(rootViewController: vc)
        
        return nav
        
    }
    
    //MARK: -时钟相关方法
    //定义时钟
    func setupTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    //所以现在每隔60秒触发一次该方法
    @objc private func updateTimer(){
        print("触发")
        
        if !NetworkManager.shared.userLogon{
        
            return
            
        }
        
        NetworkManager.shared.unreadCount { (unreadCount) in
            
            
            print("未读微博数\(unreadCount)")
            
            
            self.tabBar.items?[0].badgeValue = unreadCount>0 ? "\(unreadCount)" : nil
            
            //设置App图标的badgeNumber,从iOS8.0要用户授权之后才能显示
            
            UIApplication.shared.applicationIconBadgeNumber = unreadCount
        }
    }
    
    
}

// MARK: - UITabBarControllerDelegate
extension WBMainViewController: UITabBarControllerDelegate {
    
    /// 将要选择tabbarcontroller
    ///
    /// - parameter tabBarController: <#tabBarController description#>
    /// - parameter viewController:   viewController description
    ///
    /// - returns: 是否过去点击的那个控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("将要切换到控制器\(viewController)")
        
        //获取控制器在数组中的索引
        let index = (childViewControllers as NSArray).index(of: viewController)
        
        //重复点击首页按钮
        if selectedIndex == 0 && index == selectedIndex {
            
            //让表格滚动到顶部
            //a.获取到控制器
            
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            //滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            //刷新数据
            //同时更新UI和更新数据，机器反应不过来，人工延迟
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5, execute: {
                
                vc.loadData()
                
                
            })
            
            //清除tabbaritem的badgeNumber
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
            
        }
        
        // 判断目标控制器是否是UIViewController，如果是就不切换了
        //不是UIViewController就加载，是就不加载
        return !viewController.isMember(of: UIViewController.self)
        

    }
    
}


extension WBMainViewController {
    
     func setupNewFeatures(){
    //0.判断是否登录
        
        if !NetworkManager.shared.userLogon{
            
            return
            
        }
    //1.检测版本是否更新
    
        //2.如果更新，显示新特性，否则显示欢迎界面
        
        let v = isNewVersion ? WBNewFeatureView.newFeature():WBWelcomeView.welcomeView()
        
        //3.添加视图
        v.frame = view.bounds
        view.addSubview(v)
    
    }
    
    /// 计算型属性，不占用存储空间，类似函数
    private var isNewVersion:Bool{
    
        //1.去当前版本号
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]as? String ?? ""
        
        print(currentVersion)
        
        
        //2.取保存在 document 目录中的版本
        let path:String = ("version"as NSString).cz_appendDocumentDir()
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        
//         (try? string(contentOfFile:path)) ?? ""
        print(sandboxVersion)
        print(path)
        
        //3.将当前版本保存在沙盒
       _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        //4.返回两个版本号是否一致
        return currentVersion != sandboxVersion
        
    }
}
