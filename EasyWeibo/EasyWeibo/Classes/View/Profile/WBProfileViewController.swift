//
//  WBProfileViewController.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/13.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
let cellID = "cellID"
class WBProfileViewController: WBBaseViewController {

    
    lazy var headerView: WBProfileHeaderView = {
        let headerView = WBProfileHeaderView()
        headerView.frame = CGRect(x:0, y:0, width:SCREENW, height:kYMMineHeaderImageHeight)
        headerView.iconButton.addTarget(self, action: #selector(iconButtonClick), for: .touchUpInside)
        headerView.messageButton.addTarget(self, action: #selector(messageButtonClick), for: .touchUpInside)
        headerView.settingButton.addTarget(self, action: #selector(settingButtonClick), for: .touchUpInside)
        return headerView
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView?.tableHeaderView = headerView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

extension WBProfileViewController{


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = "yaojiayoule,xiaopengyou"
        
        
        return cell
    }
    
    //父类必须实现代理方法，子类才能重写。Swift3.0是如此，Swift2.0还不是这样
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
    }


    func iconButtonClick(){
        
    }
    
    func messageButtonClick() {
        
    }
    
    func settingButtonClick() {
        
        
    }
    

    






}
