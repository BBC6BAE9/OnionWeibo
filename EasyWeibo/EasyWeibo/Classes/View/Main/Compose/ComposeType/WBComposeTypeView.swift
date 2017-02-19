//
//  WBComposeTypeView.swift
//  EasyWeibo
//
//  Created by BBC6BAE9 on 2017/2/19.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

/// 撰写微博类型视图
class WBComposeTypeView: UIView {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // 定义按钮的数组
    let buttonInfo = [["imageName":"tabbar_compose_idea","title":"文字"],
                              ["imageName":"tabbar_compose_idea","title":"照片／视频"],["imageName":"tabbar_compose_idea","title":"长微博"],["imageName":"tabbar_compose_idea","title":"签到"],["imageName":"tabbar_compose_idea","title":"点评"],["imageName":"tabbar_compose_idea","title":"更多"],
                              
                              ["imageName":"tabbar_compose_idea","title":"好友圈"],["imageName":"tabbar_compose_idea","title":"微博相机"],["imageName":"tabbar_compose_idea","title":"音乐"],
                              ["imageName":"tabbar_compose_shooting","title":"拍摄"],
                                                            ]
    
    
    //有了XIB这个地方就不用留了
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        backgroundColor = UIColor.cz_random()
    //
    //
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    
    class func composeTyperView()->WBComposeTypeView{
        
        
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        //XIB默认加载时600x600
        v.frame = UIScreen.main.bounds
        v.seupUI()
        return v
        
    }
    
    func show(){
        // 将当前视图添加到 根部视图控制器
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else{
            return
        }
        
        vc.view.addSubview(self)
        
    }
    
    
    /// 按钮点击监听方法
    func clickButton(){
        
        print("点我......")
    }
    
    
    
    @IBAction func close(_ sender: Any) {
        
        removeFromSuperview()
        
    }
}



// MARK: - 让extension所有的函数都私有
extension WBComposeTypeView{
    
    func seupUI(){
        
//        let btn = WBComposeTypeButton.composeTypeButton(imageName: "tabbar_compose_more", title: "have a try")
//        
//        btn.frame = CGRect(x: 100 , y: 100, width: 100, height: 100)
//        //添加监听方法
//        btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
//        
//        addSubview(btn)
        
        //0.强行更新布局，拿到scrollView按钮
        layoutIfNeeded()
        //1.向ScrollView添加视图
        scrollView.backgroundColor = .orange
        let rect = scrollView.bounds
        let v = UIView(frame: rect)
        
        //2.向视图添加按钮
        addButton(v: scrollView, idx: 0)
        
        
        //3.将视图添加到 scrollView
        
        addSubview(v)
    }
    
    /// 向v中添加按钮，按钮的数组索引从idx开始
    func addButton(v:UIView, idx: Int){
        let count = 6
        for i in idx..<(idx + count){
        
        //从数组字典中获取图像名称
           let dict =  buttonInfo[i]
            
            if idx >= buttonInfo.count{
            break
            }
            //因为这个地方的key可能会写错，所以guard一下
            guard let imgName = dict["imageName"],
                let title = dict["title"] else{
            continue
            }
            
            let btn = WBComposeTypeButton.composeTypeButton(imageName: imgName, title: title)
        
            v.addSubview(btn)
        }
        
        
    }
    
}
