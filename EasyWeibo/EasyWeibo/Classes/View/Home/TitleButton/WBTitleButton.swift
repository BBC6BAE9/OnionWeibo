//
//  WBTitleButton.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/21.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    //title如果是nil 就显示首页
    //如果不为nil，显示title和箭头图像
    init(title:String?){
        super.init(frame:CGRect())
        
        if title == nil {
            setTitle("首页", for:[])
        }else{
            setTitle(title, for:[])
            
           setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        }
        
        //2.设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        setTitleColor(UIColor.darkGray, for: .normal)
        //3.设置大小
        sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
