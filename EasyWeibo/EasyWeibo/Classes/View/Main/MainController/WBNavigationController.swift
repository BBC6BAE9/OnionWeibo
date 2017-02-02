//
//  WBNavigationController.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/13.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏默认的导航
        navigationBar.isHidden = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            //判断控制器类型
            if let vc
                = viewController as? WBBaseViewController{
                
                 var title = "返回"
                
                //只有一个子控制器，显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    //显示首页的标题
                    
                    title = (childViewControllers.first?.title) ?? "返回"
                    
                }
                //判断控制器的级数
                //取出自定义的item
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action:#selector(popToParent),isbackbutton:true)
        }
      
        }
    
        super.pushViewController(viewController, animated: true)
}
    
    
    
    /// pop到上一级ViewController
    @objc private func popToParent(){
    popViewController(animated: true)

    
    }
    
}
