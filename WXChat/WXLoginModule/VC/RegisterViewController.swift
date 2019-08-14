//
//  RegisterViewController.swift
//  login
//
//  Created by gwj on 2019/6/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class RegisterViewController: InputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .register
    }
    
    
    //点击注册
    override func clickButton() {
        let urlString = WXApiManager.getRequestUrl("manKeep/register")
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: ["tgusetaccount":account,"tgusetpassword":password,"code":code], successBlock: { (result) in
            let dic = result as! [String:Any]
            let code = dic["code"] as! Int
            if code == 200{
                //成功
                //showalert
                self.navigationController?.popViewController(animated: true)
            }else{
                let msg = dic["msg"] as! String
                MBProgressHUD.showError(msg)
            }
            print(result)
        }) { (error) in
            print(error)
        }
        
    }
    override func getCode(num: String) {
        let urlString = WXApiManager.getRequestUrl("manKeep/checkPhone")
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: ["tgusetaccount":num,"checktype":"1"], successBlock: { (result) in
            print(result)
            let dic = result as! [String:Any]
            let code = dic["code"] as! Int
            if code == 200{
                //成功
                //showalert
                self.navigationController?.popViewController(animated: true)
            }else{
                let msg = dic["msg"] as! String
                MBProgressHUD.showError(msg)
            }
        }) { (error) in
            print(error)
        }
    }
}
