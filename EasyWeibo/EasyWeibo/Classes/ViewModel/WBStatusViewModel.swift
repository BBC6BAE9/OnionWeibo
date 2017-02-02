//
//  WBStatusViewModel.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/23.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//
/**
 我是用来管理单条数据的
 */
import Foundation
//单条微博的视图模型
//如果没有任何父类，如果想跟踪调试输出调试信息，做两件事
//-遵守协议 CustomStringConvertible
//-实现 description 计算型属性
class WBStatusViewModel: CustomStringConvertible{
    
    var status :WBStatus
    
    /// 会员图标-存储型属性（用内存换CPU，内存占用多了可以释放，占用CPU直接会造成卡顿）
    //为了性能考虑，应做到以下几点
    //-尽量少计算,所有素材提前准备好
    //-不要设置圆角头像，不只是这个，所有的渲染的属性都需要注意
    //不要动态创建控件，所有的空间都要提前创建好，根据数据显示／隐藏
    //cell中的层次越少越好，数量越少越好
    //<核心动画>一书中说：性能好不好，要测量，不要推测
    var memberIcon: UIImage?
    /// 构造函数
    ///
    /// - parameter model: 微博模型
    ///
    /// - returns: 微博的视图模型
    /**认证类型
     - -1没有认证
     - 0认证用户
     - 2 3 5企业认证
     - 220达人
     
     */
    var vipIcon:UIImage?
    //转发数显示
    var retweetStr:String?
    
    //评论数显示
    var commentStr:String?
    
    //点赞数显示
    var likeStr:String?
    ///配图视图大小（默认为零）
    var pictureViewSize = CGSize()
    
    //如果是被转发的微博，其原创部分一定没有图
    var picURLs: [WBStatusPicture]? {
        // 如果有被转发的微博，返回被转发微博的配图
        // 如果没有被转发的微博，返回原创微博的配图
        // 如果都没有，返回 nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 被转发微博的文字
    var retweetText: String?
    
    
    /// 行高
    var rowHeight:CGFloat = 0
    
    /// 给定转发数量
    /// - parameter count:   待转换的数量
    /// - parameter defaultString: 默认显示的字符串(转发，评论，赞)
    /// - returns: 返回显示结果
    /**
     
     =0      显示默认标题
     <10000  显示实际数字
     >10000  显示X.XX万
     
     */
    private func countString(count:Int,defaultString:String)->String{
        
        if count == 0 {
            return defaultString
        }
        
        if count < 1000 {
            
            return count.description
        }
        
        return String(format: "%.02f万",Double(count)/10000)
    }
    
  
    init(model: WBStatus) {
        self.status = model
        //会员等级0-6
        
        //警告⚠️，回头来检查这个地方有没有风险
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            
            memberIcon = UIImage(named: imageName)
        }
        
        // 认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        //设置工具条的显示文字
        retweetStr = countString(count:status.reposts_count, defaultString: "转发")
        
        commentStr = countString(count:status.comments_count, defaultString: "评论")
        
        likeStr = countString(count:status.attitudes_count, defaultString: "赞")
        
        //计算配图模型大小（有原创的计算原创的，没有原创的计算转发的）
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        
        //设置被转发微博的文字
        retweetText = "@"+(status.retweeted_status?.user?.screen_name ?? "")+":"+(status.retweeted_status?.text ?? "")
       
        //设置行高
        updateRowHeight()
    }
    
    /// 根据当前视图模型计算行高
    private func updateRowHeight(){
        
        //原创微博：顶部分隔实图（12）+间距+头像高度（34）+间距（12）+正文高度（计算）+间距（12）+配图视图高度（需要计算）+间距（12）+底部视图（35）
        //被转发微博：顶部分隔视图（12）+间距（12）+头像高度（34）+间距（12）+正文高度（12）+间距（12）+间距（12）+转发文本高度（需要计算）+间距（12）+配图视图高度（计算）+间距（12）+底部视图高度（35）
        
        /// 原创微博字号
        let originalFont = UIFont.systemFont(ofSize: 15)
        
        /// 转发微博字号
        let retweeetedFont = UIFont.systemFont(ofSize: 14)
        
        let margin: Float = 12
        let iconHeight: Float = 34
        let toolbarHeight: Float = 35
        let viewSize = CGSize(width: UIScreen.cz_screenWidth()-CGFloat(2*margin), height: CGFloat(MAXFLOAT))
        
        var height: Float = 0
        //1.计算顶部位置
        height = margin*2 + iconHeight + margin
       
        //2.正文高度
        
        if let text = status.text{
        /**
             参数
             -1）预期尺寸，宽度固定，高度尽量高
             -2）选项，换行文本，统一使用.usesLineFragmentOrigin
             -3）制定字体字典
             */
           height += Float((text as NSString).boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName:originalFont], context: nil).height)
        
        }
        
        //3.判断是否转发微博
        
        //转发微博
        if status.retweeted_status != nil {
            height += 2*margin
            //准发文本的高度
            if let text = retweetText{
            
                height += Float((text as NSString).boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName:retweeetedFont], context: nil).height)
           
            }
        }
      //转发带图
        if status.retweeted_status != nil && status.retweeted_status?.pic_urls?.count != 0{
            
            height += margin
            
        }
        
        //原创微博带配图
        if status.retweeted_status == nil && status.pic_urls?.count != 0{
            
            height += margin
    
        }
        
        //4.计算配图视图
        height += Float(pictureViewSize.height)
        
        height += margin
        
        //底部工具栏
        height += toolbarHeight
        
        //使用属性记录属性
        rowHeight = CGFloat(height)
        
    }
    
    /// 根据图片数量计算picView的尺寸
    ///
    /// - parameter count: 图片的数量
    ///
    /// - returns: 尺寸
    private func calcPictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil {
            return CGSize()
        }
        
        // 计算高度
        // 1> 根据 count 知道行数 1 ~ 9
        let row = (count! - 1) / 3 + 1
        
        // 2> 根据行数算高度
        let height: CGFloat = CGFloat(row) * WBStatusPictureItemWidth +
        CGFloat(row - 1) * WBStatusPictureViewInnerMargin
                
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }

    
    var description: String{
        
        return status.description
        
    }
    
    /// 使用单个图像更新配图视图的大小（是public的，别写错了）
    ///注意长微博（特别长特别长的那种--长到宽度只有一个点，这样在真机上用户根本就点不到）
    ///
    /// - parameter image:
    func updateSingleImageSize(image:UIImage){
        var size = image.size
        
        //过宽处理
        let maxWidth:CGFloat = 300
        
        if size.width>maxWidth{
        
            size.height = maxWidth
        //等比例调调整宽度
        size.height = size.width * image.size.height/image.size.width
        
        }
        
        //过窄处理
        
        let minWidth:CGFloat = 20
        
        if size.width<minWidth{
         
            size.height = minWidth
            //特殊处理一下长度
            size.height = size.width * image.size.height/image.size.width/4
           
        }
       
        pictureViewSize = size
        
        //更新行高
        updateRowHeight()
    
    }
    
}
