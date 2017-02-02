//
//  WBVisitorView.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/17.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

//在开发中能使用颜色就不要使用头像，颜色的效率更高
class WBVisitorView: UIView {
    //非私有，让拥有我的人能够拿到这两个控件
    lazy var registerButton: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    
    lazy var loginButton: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    var visitorInfo:[String:String]?{
        
        didSet{
            
            
            guard let imageName = visitorInfo?["imageName"],let message = visitorInfo?["message"] else{
                return
            }
            tipLabel.text = message
            if imageName == "" {
                return
            }
            houseIconView.image = UIImage(named:imageName)
            
            //其他控制器的访客视图不需要显示小房子
            runnerView.isHidden = true
            maskIconView.isHidden = true
            
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //设置访客信息
    /// 使用字典设置访客视图信息
    ///
    /// - parameter dict: [imageName/Message]
    func setupInfo(dict:[String:String]){
        
        
        
    }
    
    
    //MARK：-私有控件
    
    
    //遮罩图像
    private lazy var maskIconView = UIImageView(image: UIImage(named:"visitordiscover_feed_mask_smallicon"))
    
    //转轮
    private lazy var runnerView = UIImageView(image: UIImage(named:"visitordiscover_feed_image_smallicon"))
    
    // 小房子
    private lazy var houseIconView = UIImageView(image:UIImage(named: "visitordiscover_feed_image_house"))
    
    //(在懒加载属性只有调用UIKIt的指定构造函数，不需要在后面添加“：UILabel”，其他的都需要使用类型，反正你都加上永远都没错)
    
    private lazy var tipLabel:UILabel = UILabel.cz_label(withText: "关注一些人，回看这里有什么惊喜关注一些人，回看这里有什么惊喜",
                                                         fontSize: 14,
                                                         color: UIColor.darkGray)
    
    func setupUI(){
        
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        //1.添加控件
        
        
        addSubview(runnerView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        
        //设置文本居中
        tipLabel.textAlignment = .center
        
        //2.取消autoresizing（autolayout和autoresizing是不能共存的）
        for v in subviews{
            v.translatesAutoresizingMaskIntoConstraints = false
            
            
            //3.添加自动布局
            
            let margin: CGFloat = 20
            
            //转轮视图
            addConstraint(NSLayoutConstraint(item: runnerView,
                                             attribute:.centerX,
                                             relatedBy:.equal,
                                             toItem:self,
                                             attribute:.centerX,
                                             multiplier: 1.0,
                                             constant:0
                
            ))
            
            addConstraint(NSLayoutConstraint(item: runnerView,
                                             attribute:.centerY,
                                             relatedBy:.equal,
                                             toItem:self,
                                             attribute:.centerY,
                                             multiplier: 1.0,
                                             constant:-55))
            
            //小房子
            addConstraint(NSLayoutConstraint(item: houseIconView,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: runnerView,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: 0))
            
            addConstraint(NSLayoutConstraint(item: houseIconView,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: runnerView,
                                             attribute: .centerY,
                                             multiplier: 1.0,
                                             constant: 0))
            
            //提示标签
            addConstraint(NSLayoutConstraint(item: tipLabel,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: runnerView,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: 0))
            
            
            addConstraint(NSLayoutConstraint(item: tipLabel,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: runnerView,
                                             attribute: .bottom,
                                             multiplier: 1.0,
                                             constant: margin))
            
            addConstraint(NSLayoutConstraint(item: tipLabel,
                                             attribute: .width ,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: 236))
            
            //注册按钮
            addConstraint(NSLayoutConstraint(item: registerButton,
                                             attribute: .left ,
                                             relatedBy: .equal,
                                             toItem: tipLabel,
                                             attribute: .left,
                                             multiplier: 1.0,
                                             constant: 0))
            
            addConstraint(NSLayoutConstraint(item: registerButton,
                                             attribute: .top ,
                                             relatedBy: .equal,
                                             toItem: tipLabel,
                                             attribute: .bottom,
                                             multiplier: 1.0,
                                             constant: margin))
            
            addConstraint(NSLayoutConstraint(item: registerButton,
                                             attribute: .width ,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: 118))
            
            //登录
            addConstraint(NSLayoutConstraint(item: loginButton,
                                             attribute: .right ,
                                             relatedBy: .equal,
                                             toItem: tipLabel,
                                             attribute: .right,
                                             multiplier: 1.0,
                                             constant: 0))
            
            addConstraint(NSLayoutConstraint(item: loginButton,
                                             attribute: .top ,
                                             relatedBy: .equal,
                                             toItem: tipLabel,
                                             attribute: .bottom,
                                             multiplier: 1.0,
                                             constant: margin))
            
            addConstraint(NSLayoutConstraint(item: loginButton,
                                             attribute: .width ,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: 118))
            
            // 6> 遮罩图像
            // views: 定义 VFL 中的控件名称和实际名称映射关系
            // metrics: 定义 VFL 中 () 指定的常数映射关系
            let viewDict: [String : Any] = ["maskIconView": maskIconView,
                                            "registerButton": registerButton]
            let metrics = ["spacing": 20]
            
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[maskIconView]-0-|",
                options: [],
                metrics: nil,
                views: viewDict))
            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
                options: [],
                metrics: metrics,
                views: viewDict))
            
        }
    }
    
    /// 旋转图标
    func startAnimation(){
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 15
        anim.repeatCount = MAXFLOAT
        //动画完成不删除，如果runnerView被销毁动画被一起删除
        anim.isRemovedOnCompletion = false
        runnerView.layer.add(anim, forKey: nil)
        anim.isRemovedOnCompletion = false
        //        view1.layer.removeAllAnimations()
        //        UIView.animate(withDuration: 0.2) {
        //            view1.transform = view1.transform.rotated(by: CGFloat(M_PI))
        //        }
        
    }
    
}
