//
//  WBWelcomeView.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/21.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
import SDWebImage

/// 欢迎视图
class WBWelcomeView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!

    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var iconWidthCons: NSLayoutConstraint!
    
    class func welcomeView()-> WBWelcomeView{

        let v : UIView = Bundle.main.loadNibNamed("WBWelcomeView", owner: self, options: nil)?.first as! UIView
        v.frame = UIScreen.main.bounds
        return v as! WBWelcomeView
    }
    
    
    //layoutSubView
    //自动布局系统更新完成后，会自动调用此方法
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //这个东西只是刚刚从XIB二进制的数据文件加载完成
        //还没有喝代码连线，建立起关系，所以开发时，千万不要在这个方法中处理UI
    }
    
    override func awakeFromNib() {
        //读取头像url
        guard let urlString = NetworkManager.shared.userAccount.avatar_large, let url = URL(string:urlString) else{
        return
        }
        
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named:"avatar_default_big"))
        }
    
    override func didMoveToWindow() {
        
        super.didMoveToWindow()
        
        //设置圆角(代码执行到此处时，还没有设置iconView的bounds)
        iconView.layer.cornerRadius = iconWidthCons.constant * 0.5
        iconView.layer.masksToBounds = true
        
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        self.tipLabel.alpha = 0

       
        UIView.animate(withDuration: 3.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        
                        // 更新约束
                        self.layoutIfNeeded()
        }) { (_) in
            
            UIView.animate(withDuration: 2.5, animations: {
                self.tipLabel.alpha = 1
                }, completion: { (_) in
                    self.removeFromSuperview()
            })
        }
        
        
    }}
