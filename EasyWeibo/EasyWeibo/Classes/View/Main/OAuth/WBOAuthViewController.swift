//
//  WBOAuthViewController.swift
//  EasyWeibo
//
//  Created by huang on 2017/1/20.
//  Copyright © 2017年 BBC6BAE9. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        
        view = webView
        view.backgroundColor = UIColor.gray
        title = "新浪微博"
        //设置代理
        
        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", fontSize: 14, target: self, action: #selector(close), isbackbutton: true)
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充密码", target: self, action: #selector(autoFill))
        
    }
    
    //自动填充密码（直接通过js修改本地缓存的页面内容）
    //点击登录按钮，执行submit()将本地数据提交服务器
    @objc private func autoFill(){
        //准备js
        let js = "document.getElementById('userId').value = 'huanghongchn@gmail.com';"+"document.getElementById('passwd').value = 'hh123456';"
    //让webview执行js
    //和js交互中只有着一个方法
    webView.stringByEvaluatingJavaScript(from: js)
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        guard let url = URL(string: urlString)else {
            return
        }
        
        //建立请求
         let request:URLRequest = URLRequest(url:url)
        
        //加载请求
        
        webView.loadRequest(request)
        
        
    }
   
    @objc func close(){
    
        dismiss(animated: true, completion: nil)
    
        SVProgressHUD.dismiss()

    }
}
extension WBOAuthViewController:UIWebViewDelegate{


    /// webView将要加载请求
    ///
    /// - parameter webView:        webView
    /// - parameter request:        要加载的请求
    /// - parameter navigationType: 导航类型
    ///
    /// - returns: 是否加载request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //思路：如果请求地址包括http://www.baidu.com 不加载页面，否则加载页面
        
        guard let string = request.url?.absoluteString else {
            return false
        }
        
        if string.hasPrefix(WBRedirectURI) == false{
            
            return  true
            
        }
        print("加载请求\(request.url?.absoluteString)")
        //query 就是url中？之后的部分
        print("加载请求\(request.url?.query)")
        //查找字符串中查找“code=”
        
        if request.url?.query?.hasPrefix("code=") == false {
            
            print("取消授权")
            close()
            return false
            
        }
        //从query字符串中取出 授权码
       //代码走到这里，一定有查询字符串 ，并且包含“code=”
        
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        
        print("获取授权码...\(code)")
        
        //4.使用授权码获取accesstoken
        
        
        NetworkManager.shared.loadAccessToken(code:code){(isSuccess)in
        
           
            if !isSuccess{
            SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }else{

                //1>发通知
               //发送通知不关心有没有监听者，只管自己发送自己的
                 NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: WBUserLoginSuccessedNotificaton ),
                                                 object: nil)
                //2>关闭窗口
                self.close()
            }
        }

        //如果有授权成功，否则授权失败
        return true
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
    
        SVProgressHUD.dismiss()
        
    }
    
    
}
