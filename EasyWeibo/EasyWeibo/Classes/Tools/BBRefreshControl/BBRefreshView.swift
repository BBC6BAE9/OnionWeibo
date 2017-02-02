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

    //添加刷新状态
    var refreshState: BBRefreshState = .Normal{
        didSet{
        
            switch refreshState {
            case .Normal:
                tipLabel?.text = "继续使劲拉..."
                
                UIView.animate(withDuration: 0.25){
                self.tipIcon?.transform = CGAffineTransform.identity
                }
                
                //显示图标，
                tipIcon?.isHidden = false
                //停止转动
                indicator?.stopAnimating()
                
            case .Pulling:
                tipLabel?.text = "放手就刷新..."
                UIView.animate(withDuration: 0.25){
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI-0.00001))
                    /*想要实现360动画，使用CABaseAnimation*/
                    
                }
                            case .WillRefresh:
                tipLabel?.text = "正在刷新中..."
                //隐藏显示图标，
                tipIcon?.isHidden = true
                //显示菊花
                indicator?.startAnimating()
            }
       }
    }
    //父视图的高度
    var parentViewHeight:CGFloat = 0
    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView?
    
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel?
    
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    
    class func refreshView()-> BBRefreshView{
    
    let nib = UINib(nibName: "BBAnimationRefreshView", bundle: nil)
    
        return nib.instantiate(withOwner: nil, options: nil)[0] as! BBRefreshView
    
    }

}
