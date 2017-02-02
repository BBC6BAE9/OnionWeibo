
//
//  WBStatusListViewModel.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/19.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//
/**
  我是用来管理网络数据的
 */
import Foundation
import SDWebImage

//直接选swift文件，可以不继承任何父类

//／微博数据列表
/*
 - 如果类需要使用“KVC”（因为KVC是NSObject中定义的），或者字典转模型框架设置（里面会使用kvc的东西），这时候类就需要继承自NSObject
 - 如果只是封装一些逻辑（写了一些函数），可以不使用任何父类，好处：更加轻量级（类越是轻量级，当这个类载入内存的时候开销就越小）
 - 建议使用OC再次写一遍（OC中没有不带父类的，一律继承自NSObject就好）
 */

/*
 
 使命：负责微博数据的处理
 - 1.字典转模型
 - 2.下拉上拉处理
 
 */

//上拉刷新最大尝试次数
private let MAX_PULLUP_TRY_TIMES = 100000
class WBStatusListViewModel{
    
    private var pullupErrorTimes = 0
    
    lazy var statusList = [WBStatusViewModel]()
    
    /// 加载微博列表
    /// - parameter completion: 是否上拉刷新标记
    /// - parameter completion: 完成毁掉（网络请求是否成功）
    func loadStatus(pullup:Bool = false,completion:@escaping (_ isSuccess:Bool,_ shouldRefresh:Bool)->()){
        
        
        //判断是否是上拉刷新
        if pullup && pullupErrorTimes > MAX_PULLUP_TRY_TIMES {
            
            completion(true, false)
            
            return
            
        }
        
        let since_id = pullup ? 0: (statusList.first?.status.id ?? 0)
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        
        //发起网络请求加在微博数据（字典的数组）
        NetworkManager.shared.statusList(since_id: since_id, max_id: max_id ) {
            (list, isSuccess) in
            
            
            
            //0.如果网络请求失败，直接返回
            
            if !isSuccess{
                
                completion(false, false)
                return
                
            }
            //遍历字典数组，字典=》模型=》视图模型，将视图模型添加到数组
            
            var array = [WBStatusViewModel]()
            
            for dic in list ?? []{
                
                //1.创建微博模型
                
                let status = WBStatus()
                //2.使用字典设置模型数值
                
                status.yy_modelSet(with: dic)
                
                //3.使用“微博“模型创建”微博视图“模型
                let viewModel = WBStatusViewModel(model: status)
                
                //添加到数组
                array.append(viewModel)
            }
            
            //视图模型创建完成
            print("刷新到\(array.count)条数据\(array)")
            
            if pullup {
                // 上拉刷新结束后，将结果拼接在数组的末尾
                self.statusList += array
            } else {
                // 下拉刷新，应该将结果数组拼接在数组前面
                self.statusList = array + self.statusList
            }
            
            
            if pullup && array.count == 0 {
                
                completion(isSuccess, false)
                
            }else{
                //闭包像参数一样能传递
                self.cacheSingleImage(list: array,finished: completion)
                
            }
        }
    }
    
    /// 本次刷新出的微博中
    ///
    /// 应该在完成缓存，并且设置单张尺寸后再完成回调
    /// - parameter list: 本次下载的视图模型数组
    private func cacheSingleImage(list:[WBStatusViewModel],finished:@escaping (_ isSuccess:Bool,_ shouldRefresh:Bool)->()){

        
        
        /// 记录数据长度
        var length = 0
        //调度组
        let group = DispatchGroup()
        
        
        //遍历数组，只有单张图像的进行缓存
        for  vm in list {
            if vm.picURLs?.count != 1{
                
                continue
                
            }
            
            //执行到此，数组中有且仅有1个，获取图像模型
            guard let pic = vm.picURLs?[0].thumbnail_pic,let url = URL(string: pic) else{
                continue
            }
            
            
            print("要缓存的URL是\(url)")
            
            //downLoad是SDWebImage的核心方法
            //图像下载完成后，会自动保存在沙盒中，文件路径是沙盒的md5
            //如果沙盒中存在已经缓存的图像，后续使用SDWebImage通过URL加载图像，都会加载本地沙盒图像
            //不会发起网络请求，同时回调方法，同样回调用（节约流量）
            //方法还是同样的方法，调用还是同样的调用，不过在内部不会在此发起网络请求
            /**注意点：住过缓存的图像累计很大，找后台要接口*/
            
            //a>入组
            group.enter()
            
            SDWebImageDownloader.shared().downloadImage(with: url, options:.lowPriority, progress: nil, completed: { (iamge, _, _, _) in
               
                //转换成二进制数据
                if let image = iamge,let data = UIImagePNGRepresentation(image)
                {
                    //NSData中是length属性，在Foundatation中是count
                    length += data.count
                    
                    //图像缓存成功，更新配图视图的大小
                    vm.updateSingleImageSize(image: image)
                    
                    
                }
                
                print("缓存的图像是\(iamge)长度是\(length)")
                
                //b>出组
                group.leave()
            })
        }
        
        
        //调度组监听
        group.notify(queue: DispatchQueue.main) {
            
            print("图像缓存完成,数据量为\(length/1024)K")
            
            finished(true,true)
        }
        
     }
    
}

