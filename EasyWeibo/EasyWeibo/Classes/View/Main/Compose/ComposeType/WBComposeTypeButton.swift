//
//  WBComposeTypeButton.swift
//  EasyWeibo
//
//  Created by BBC6BAE9 on 2017/2/19.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

//UIControl内置了touchUpinside响应
class WBComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    /// 使用图像名称和title创建按钮，布局从XIB加载
    class func composeTypeButton(imageName:String,title:String)->WBComposeTypeButton{
    
    let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        return btn
    
    }
    
}
