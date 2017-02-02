//
//  WBDmeoViewController.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/14.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit

class WBDmeoViewController: WBBaseViewController {
    
    
    
    override func viewDidLoad() {
        
        setupNavigationBar()
        setupTabaleView()
        title = "第\(navigationController?.childViewControllers.count ?? 0)页面"
        
    }
    
    //加载数据
    override func loadData() {
        
        
        


        
    }
    @objc private func showNext(){
        
        
        let vc = WBDmeoViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    override func setupTabaleView() {
        super.setupTabaleView()
         navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
    }
}
