//
//  WBStatusPicture.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/24.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {
    
    var viewModel:WBStatusViewModel?{
        
        didSet{
            
            
            caculateViewSize()
           
            
        }
        
        
        
    }

    @IBOutlet weak var heightCons: NSLayoutConstraint!

    private func caculateViewSize(){
        
        //处理宽度
        //1>单图，根据配图视图的大小，修改subview[0]的宽高
        
        if viewModel?.picURLs?.count == 1{
            
            //获取第零个图像的视图
            let viewSize  = viewModel?.pictureViewSize ?? CGSize()
            let v = subviews[0]
            //宽高千万别颠倒
            v.frame = CGRect(x: 0,
                             y: 0,
                             width: viewSize.width,
                             height: viewSize.height
            )
            
        }else{
            //2>多图，恢复subView[0]的高度，保证九宫格的完整布局
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: 0,
                             width: WBStatusPictureItemWidth,
                             height: WBStatusPictureItemWidth
            )
            

        }
        
        
        //修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0

        
    }
    
    //配图视图数组
    var urls: [WBStatusPicture]?{
        didSet{
            
            //1.隐藏所有的imageView
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            //2.遍历url数组顺序设置图像
            for url in urls ?? [] {
                
                //3.获得对应索引的imageView
                let iv = subviews[index]as! UIImageView
                
                //四张图片的处理
                if  index == 1 && urls?.count == 4{
                    
                    index += 1
                    
                }
                
                //设置图像的显示
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
                index += 1
                //4.设置图像
                iv.cz_setImage(urlString:
                    url.thumbnail_pic, placeholderImage: nil)
                
                
                //5.显示图像
                iv.isHidden = false
                
            }
        }
        
    }
    
    override func awakeFromNib() {
        
        setupUI()
        
    }
}

extension WBStatusPictureView {
    //设置界面
    //cell中所有的空间都是提前准备好根据数据进行显示和隐藏
    //不要动态创建空间
    func setupUI(){
        
        
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: 0, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        
        for i in 0..<count*count{
            let iv = UIImageView()
            iv.backgroundColor = superview?.backgroundColor
            
            //行
            let row = CGFloat(i/count)
            
            //列
            let col = CGFloat(i%count)
            
            let xOffSet = col*(WBStatusPictureItemWidth+WBStatusPictureViewInnerMargin)
            let yOffSet = row*(WBStatusPictureItemWidth+WBStatusPictureViewInnerMargin)
            iv.frame = rect.offsetBy(dx: xOffSet, dy: yOffSet)
            
            addSubview(iv)
            
        }
        
        
    }
    
}
