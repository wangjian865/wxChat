//
//  WXWebViewController.swift
//  WXChat
//
//  Created by WX on 2019/8/16.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit
import WebKit
class WXWebViewController: UIViewController {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let configuration = WKWebViewConfiguration.init()
        webView = WKWebView.init(frame: view.bounds, configuration: configuration)
        if title == "竹简服务协议"{
            webView.load(URLRequest.init(url: URL.init(string: "http://www.ubambook.cn:81/images/agreement.html")!))
        }else if title == "提示"{
            webView.load(URLRequest.init(url: URL.init(string: "http://www.ubambook.cn:81/images/emailproblem.html")!))
        }else{
            webView.load(URLRequest.init(url: URL.init(string: "http://www.ubambook.cn:81/images/privacy.html")!))
        }
        view.addSubview(webView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
