//
//  BBRefreshControl.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/28.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
//刷新状态切换的临界点
private let BBRefreshOffSet: CGFloat = 133

/// 刷新状态
///
/// - Normal:      普通状态什么都不做
/// - Pulling:     超越临界点，如果放手，进行刷新
/// - willRefresh: 超过临界点，并且放手

enum BBRefreshState{
    
    case Normal
    case Pulling
    case WillRefresh
    
}

//负责刷新的逻辑处理
/// 刷新控件
class BBRefreshControl: UIControl {
    
    //MARK：属性
    //滚动视图(tableView和CollectionView)的父视图
    private weak var scrollView: UIScrollView?
    
    
    /// 刷新视图
    private lazy var refreshView:BBRefreshView = BBRefreshView.refreshView()
    
    /// 构造函数
    init(){
        super.init(frame: CGRect())
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //        setupUI()
        
    }
    
    
    /// 本视图从父视图移除
    override func removeFromSuperview() {
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
    /// addSubView回调用这个玩意儿
    /// 当添加到父视图的时候，newSuperView是父视图
    /// 当父视图被移除的时候，newSuperView是nil
    //观察者模式在不使用的时候要记得移除
    //常用的两种观察者模式：1）KVO：如果不释放会崩溃
    //                      2）通知中心：如果不释放，什么也不会发生，但                        会发生内存泄漏，会有多次注册的可能
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        print(newSuperview)
        
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        //记录父视图
        scrollView = sv
        //KVO监听父视图的ContentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    /// 所有KVO会调用此方法
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //        print(scrollView?.contentOffset)
        
        guard let sv = scrollView else {
            return
        }
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        //往上推就直接返回了
        if height<0 {
            
            return
            
        }
        
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        
        
        //--传递父视图的高度--
        refreshView.parentViewHeight = height
        
        //判断临界点（拉的大刷新，拉的小没反应）-临界点只需要判断一次
        // 判断临界点 - 只需要判断一次
      
        if sv.isDragging {
            
            if height > BBRefreshOffSet && refreshView.refreshState == .Normal{
            print("放手刷新")
                refreshView.refreshState = .Pulling
            }else if height <= BBRefreshOffSet && refreshView.refreshState == .Pulling{
            print("继续使劲")
                refreshView.refreshState = .Normal
            }
            
        }else{
        //放手
            if refreshView.refreshState == .Pulling{
            print("准备开始刷新")
                //刷新结束之后，将状态修改为normal
          beginRefreshing()
               //发送刷新数据事件
                sendActions(for: .valueChanged)
            }
           
        }
       
    }
    
    
    /// 开始刷新
    func beginRefreshing(){
        
        print("开始刷新")
        
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState == .WillRefresh {
            
            return
            
        }
        
        //设置刷新视图的状态
        refreshView.refreshState = .WillRefresh
        
        //调整表格艰巨
        var inset = sv.contentInset
        
        print(inset.top)
        
        inset.top += BBRefreshOffSet
        
        sv.contentInset = inset
       //设置刷新视图的父视图的高度
        refreshView.parentViewHeight = BBRefreshOffSet
    }
    
    /// 结束刷新
    func endRefreshing(){
        
        print("结束刷新")
        
        //恢复刷新视图的状态
        refreshView.refreshState = .Normal
        //恢复表格视图的 cotentInset
        
        guard let sv = scrollView else{
        
        return
            
        }
        
        //判断是否正在刷新，如果不是，直接返回
        //防止表格间距错乱
        if refreshView.refreshState == .WillRefresh {
            
            
            return
            
            
        }

        var inset = sv.contentInset
        print("尼玛\(inset)")
        inset.top -= BBRefreshOffSet
        
        print("尼玛\(inset)")
        sv.contentInset = inset
    }
    
    private func setupUI(){
        
        backgroundColor = superview?.backgroundColor

        //超出边界不显示
//        clipsToBounds = true
        //addSubview 从XIB加载出来，默认是XIB制定的宽高
        addSubview(refreshView)
        
        //自动布局-设置XIB的自动布局需要制定XIB的宽高约束
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        //自己开发的框架，里面的东西最好用原生的东西写
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem:self ,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self ,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem:nil ,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem:nil ,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
        
    }
}

