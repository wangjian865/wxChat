//
//  ConfirmViewController.swift
//  login
//
//  Created by gwj on 2019/6/18.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

//找回密码时的第二次确认页面
class ConfirmViewController: InputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "找回密码"
        type = .confirm
    }
    
    //点击设置新密码
    override func clickButton() {
        let urlString = WXApiManager.getRequestUrl("manKeep/updateTgusetPwd")
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: ["tgusetaccount":account,"tgusetpassword":password,"code":code], successBlock: { (result) in
            if let dic = result as? [String:Any],let msg = dic["msg"] as? String{
                MBProgressHUD.showSuccess(msg)
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }) { (error) in
            print(error)
        }
    }

}
