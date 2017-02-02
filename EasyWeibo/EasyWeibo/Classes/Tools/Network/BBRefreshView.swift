//
//  BBRefreshView.swift
//  刷新控件
//
//  Created by huang on 2017/1/28.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
//负责刷新UI相关
class BBRefreshView: UIControl {

    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView!
    
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel!
    
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    class func refreshView()-> BBRefreshView{
    
    let nib = UINib(nibName: "BBRefreshView", bundle: nil)
    
        return nib.instantiate(withOwner: nil, options: nil)[0] as! BBRefreshView
    
    }

}
