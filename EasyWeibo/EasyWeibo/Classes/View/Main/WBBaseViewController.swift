//
//  WBBaseViewController.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/13.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//
/**
 
 **“代理”最主要的目的就是解耦**
 为了方便代码不停的被复用
 这里呢，是紧耦合（visitorView就仅仅的被Base使用）
 如果不是需要多次复用，这么使用就可以
 如果以后有需要，也可以再次添加代理的代码
 
 */
import UIKit
//作为主程序框架的搭建应该把给别人的影响降到最小

//extension包装代码块使代码更容易阅读
//extension中不能重写符父类方法，是子类的职责，扩展是对类的扩展


//面试题：OC中支持多继承么？如果不支持如何替代
//答案：使用协议替代
//Swift中的写法更类似于多继承
//class WBBaseViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

/// 所有主控制器的基类控制器
class WBBaseViewController: UIViewController {
    
    //访客视图信息
    var visitorInfoDictionary:[String:String]?
    
    
    //刷新控件
    var refreshControl:BBRefreshControl?
    
    //-如果用户没有登录，就不创建（所以这个地方不能用懒加载）
    var tableView: UITableView?
    
    //上拉刷新标记
    var isPullUp:Bool = false
    
    //自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    
    /// 自定义导航条目
    lazy var navItem = UINavigationItem()
    
    /// 重写item的setter
    override var title: String?{
        
        didSet{
            navItem.title = title
        }
        
    }
    
    override func viewDidLoad() {
        
        setupUI()
        NetworkManager.shared.userLogon ? loadData(): ()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotificaton), object: nil)
    }
    
    //不加objc通知中心处理不倒
    //Swift中参数改了，监听方法中不用改，在OC中需要修改
    @objc private func loginSuccess(n:NotificationCenter){
    
        print("登录成功\(n)")
    
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        // 更新UI
        //在访问view的getter，如果view == nil会调用laodView->ViewDidload,又重新执行了一遍
        
        view = nil
        
        //**关键代码*   注销通知——>重新执行到viewdidload是会再次注册，避免通知重复注册
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData(){
        
        
    }
    
    //MARK: - 设置界面
    private func setupUI(){
        
        view.backgroundColor = UIColor.cz_random()
        
        //取消自动缩进-会缩进20个点
        //**********************
        //这个属性一定要记得调整一下
        //**********************
        automaticallyAdjustsScrollViewInsets = false
        //添加导航条
        setupNavigationBar()
        
        NetworkManager.shared.userLogon ? setupTabaleView(): setupVisitorView()
        
    }
    
    // 设置访客视图
    private func setupVisitorView(){
        
        let visitorView = WBVisitorView(frame: view.bounds)
        view.insertSubview(visitorView, belowSubview: navigationBar)
        visitorView.startAnimation()
        visitorView.visitorInfo = visitorInfoDictionary
        
        //添加访客视图的监听
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)

        //设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target:self , action: #selector(register))

        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target:self , action: #selector(login))

    }
    
    // 设置表格视图
    func setupTabaleView(){
       
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        //这个地方必须有
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        //设置数据源方法和代理->目的：在直接实现数据源方法就OK了
        tableView?.delegate = self
        tableView?.dataSource = self
        //设置内容缩进
        tableView?.contentInset = UIEdgeInsets(top:navigationBar.bounds.height,
                                               left:0,
                                               bottom:tabBarController?.tabBar.bounds.height ?? 49,
                                               right:0)
        
        //修改指示器缩进
        tableView?.scrollIndicatorInsets = (tableView?.contentInset)!
        //设置刷新控件
        //1.实例化控件
        refreshControl = BBRefreshControl()
        //2.添加到表格视图
        tableView?.addSubview(refreshControl!)
        //3.添加监听方法（调用的本类的loadData而不是base的）
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
    }
    
    //设置导航条
    func setupNavigationBar(){
        
        view.addSubview(navigationBar)
        
        navigationBar.items = [navItem]
        //整个条子的颜色
        navigationBar.barTintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
        navigationBar.tintColor = UIColor.orange
    }
}

//MARK: -数据源方法数据源代理
extension WBBaseViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    //基类只是准备方法，子类负责具体的实现
    //子类的数据源不需要super，
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //只是保证语法上没有错误
        return UITableViewCell()
        
    }
    
    //将要显示cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //判断indexPath.row是不是最后一行
        let row = indexPath.row
        let section = tableView.numberOfSections-1
        
        if row<0 || section<0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        
        if row == (count-1) && !isPullUp {
            print("上拉刷新")
            isPullUp = true
            //开始刷新
            loadData()
        }
        
        
    }
   
    @objc func login(){
        
        print("用户登录")
        
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
        
    }
    
    @objc func register(){
        
        print("用户注册")
        
        
    }

}
