//
//  UIBarbuttonItem+Extension.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/14.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

extension UIBarButtonItem{

    /// 创建UIBarButtonItem
    ///
    /// - parameter title:    文字
    /// - parameter fontSize: 字体大小默认16号
    /// - parameter target:   监听者
    /// - parameter action:   动作
    /// - parameter isbackbutton:  是否是返回按钮，如果是加上箭头
    ///
    /// - returns: UIBarButtonItem
    
    convenience init(title:String ,fontSize: CGFloat = 16,target:Any,action:Selector,isbackbutton:Bool = false) {
      
        let btn:UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        if isbackbutton{
            let imagName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named:imagName), for: .normal)
        
            btn.setImage(UIImage(named:"\(imagName)+highlighted"), for: .highlighted)
            //添加了图片了，重新调整一下button
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)

        self.init(customView:btn)
    }



}
