//
//  WBNewFeatureView.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/21.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {

   
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var pageControll: UIPageControl!
    //进入微博
    @IBAction func enterStatus() {
        
        removeFromSuperview()
        
    }
    
    class func newFeature()-> WBNewFeatureView{
        
        let v : UIView = Bundle.main.loadNibNamed("WBNewFeatureView", owner: self, options: nil)?.first as! UIView
        v.frame = UIScreen.main.bounds
        return v as! WBNewFeatureView
    }
   
    override func awakeFromNib() {
        
        let count = 4
        let rect = UIScreen.main.bounds

        for i in 0..<count{
        let imageName = "new_feature_\(i+1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            iv.frame = rect.offsetBy(dx: CGFloat(i)*UIScreen.main.bounds.width, dy: 0)
            
        scrollView.addSubview(iv)
            //指定ScrolView的属性
            scrollView.contentSize = CGSize(width: CGFloat(count+1) * rect.width, height: rect.height)
        scrollView.bounces = false
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
           scrollView.delegate = self
            
            //按钮默认隐藏
            enterButton.isHidden = true
        }
        
    }

}



extension WBNewFeatureView:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //滚动到最后一屏让视图删除
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        //判断是否是最后一页
        if page == scrollView.subviews.count {
            
            removeFromSuperview()
        }
        enterButton.isHidden = (page != scrollView.subviews.count-1)

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        enterButton.isHidden = true
        
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)

        pageControll.currentPage = page
        
        //分页控件隐藏
        pageControll.isHidden = (page == 4)

    }

}
