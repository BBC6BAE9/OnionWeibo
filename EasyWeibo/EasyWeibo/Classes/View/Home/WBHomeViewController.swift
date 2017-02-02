//
//  WBHomeViewController.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/13.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
//定义的是全局变量，尽量使用private修饰，否则到处都可以访问
private let originalCellID = "originalcellID"
private let retweetedCellID = "retweetedCellID"

class WBHomeViewController: WBBaseViewController {
    
    //列表视图模型
    private lazy var listViewModel = WBStatusListViewModel()

    //懒加载微博数据
    lazy var statuslist = [String]()
    
    
    override func viewDidLoad() {
    
        
        super.viewDidLoad()
        //设置tableView的背景颜色和XIB设置的间隔颜色融为一体
        tableView?.backgroundColor = UIColor.cz_color(withHex: 0xF2F2F2)
        
        let tableBackImg = UIImageView(image:  UIImage(named: "jay"))
        tableView?.backgroundView = tableBackImg
        
            
    }
    
    //模拟延时加载数据-> dispatch_after
    override func loadData() {
        
        refreshControl?.beginRefreshing()

            //字典转模型，绑定表格数据
            //准备刷新
            listViewModel.loadStatus(pullup: self.isPullUp) { (isSuccess) in
                //加载数据结束

                //恢复上拉标记
                self.isPullUp = false
                //刷新表格
                self.tableView?.reloadData()
                self.refreshControl?.endRefreshing()
            }
       }
    
    //重写父类方法
    override func setupTabaleView() {
        super.setupTabaleView()
        
        //Swift调用OC的方法，返回的是instanceType不知道是否可选给btn加个类型就一劳永逸了
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", fontSize: 14, target: self, action: #selector(showFriend))
        
        //        注册cell
        tableView?.register(UINib.init(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellID)

        tableView?.register(UINib.init(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellID)

        
        //设置行高,自动行高
//        tableView?.rowHeight = UITableViewAutomaticDimension
        
        /**
         real重要啊，小朋友
         预估行高
        */
        
//        tableView?.estimatedRowHeight = 300
        
        //取消分割线
        tableView?.separatorStyle = .none
        setupNavTitle()
    }
    
    
    private func setupNavTitle(){

        let title = NetworkManager.shared.userAccount.screen_name
        let button = WBTitleButton(title: title)

        button.addTarget(self, action: #selector(clickTitle), for: .touchUpInside)
        navItem.titleView = button
        }
    
    @objc private func clickTitle(btn:UIButton){
        
        //设置选中状态
        btn.isSelected = !btn.isSelected
    
    }
    
    @objc private func showFriend(){
        
        let vc = WBDmeoViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        print("显示朋友列表")
        
    }

    //MARK: Delegate&DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //取出时图模型根据时图模型来判断可重用Cell
        
        let viewModel = listViewModel.statusList[indexPath.row]

        let cellID = (viewModel.status.retweeted_status != nil) ? retweetedCellID : originalCellID
        
        //FIXME: -区分ID
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! WBStatusCell
        
        cell.viewModel = viewModel
        
        return cell
    }
    
    //父类必须实现代理方法，子类才能重写。Swift3.0是如此，Swift2.0还不是这样
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //根据indexPath获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        
        //返回计算好的行高
        return vm.rowHeight
    }
}

