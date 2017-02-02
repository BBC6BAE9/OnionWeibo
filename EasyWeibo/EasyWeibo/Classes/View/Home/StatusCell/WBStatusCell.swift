//
//  WBStatusCell.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/22.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {
    
    //头像
    @IBOutlet weak var iconView: UIImageView!
    
    //姓名
    @IBOutlet weak var nameLabel: UILabel!
    
    //会员图标
    @IBOutlet weak var memberIcon: UIImageView!
    
    //发布时间
    @IBOutlet weak var timeLabel: UILabel!
    
    //微博来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    //认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    
    //正文
    @IBOutlet weak var statusLabel: UILabel!
    
    //底部工具栏
    @IBOutlet weak var toolBar: WBStatusToolBar!
    
    //配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    //pictureView的顶部视图
    @IBOutlet weak var pictureTopCons: NSLayoutConstraint!
    
    //被转发微博的文字（不一定有这个属性，一个cell->两个XIB）
    @IBOutlet weak var retweetedLabel: UILabel?
    
    //微博视图模型
    var viewModel: WBStatusViewModel?{
        didSet{
            
            //设置微博文本
            statusLabel.text = viewModel?.status.text
            nameLabel.text = viewModel?.status.user?.screen_name
            
            //判断mb_rank的值，根据值来设置属性
            memberIcon.image = viewModel?.memberIcon
            
            //认证图标
            vipIconView.image = viewModel?.vipIcon
            
            //用户头像
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named:"avatar_default_big")!,isAvatar: true)
            
            //底部工具栏
            toolBar.viewModel = viewModel
            
            pictureView.viewModel = viewModel
            
            //调整因视图显示隐藏而错乱的白边
            adjustMargin()
            
            //设置配图（被转发和原创）
            pictureView.urls = viewModel?.picURLs
            //设置被转发的微博的文字（和上面的retweetStr千万要区分开，设置错了真麻烦，😢）
            retweetedLabel?.text = viewModel?.retweetText
            
        }
    }
   
    private func adjustMargin(){
        
        
        //原创纯文字微博
        if viewModel?.status.retweeted_status == nil && viewModel?.status.pic_urls?.count == 0 {
            
            pictureTopCons.constant = 0
            
        }
        
        //原创微博带配图
        if viewModel?.status.retweeted_status == nil && viewModel?.status.pic_urls?.count != 0{
            
            pictureTopCons.constant = 12
        }
        //转发纯文字微博
        
        if viewModel?.status.retweeted_status != nil && viewModel?.status.retweeted_status?.pic_urls?.count == 0{
            
            pictureTopCons.constant = 0
            
        }
        
        //转发带图
        if viewModel?.status.retweeted_status != nil && viewModel?.status.retweeted_status?.pic_urls?.count != 0{
            
            pictureTopCons.constant = 12
            
        }
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //离屏渲染(异步绘制)
        layer.drawsAsynchronously = true
        
        //栅格化(异步绘制之后，会独立的生成一张图像，cell在屏幕上滚动的时候本质上是滚动这张图片)
        //cell优化要尽量减少涂层的数量，栅格化相当于只有一层，当停止滚动的时候依然可以进行交互，但是栅格化有个缺点就是不清楚，必须制定分辨率
        layer.shouldRasterize = true
        
        //指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
   
}
