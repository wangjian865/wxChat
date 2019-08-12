//
//  GetPasswordViewController.swift
//  login
//
//  Created by gwj on 2019/6/18.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class GetPasswordViewController: InputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .getPassword
        title = "找回密码"
    }
    
    override func clickButton() {
        //        FIXME:校验验证码
        let vc = ConfirmViewController()
        vc.account = account
        vc.code = password
        navigationController?.pushViewController(vc, animated: true)
    }
    override func getCode(num: String) {
        let urlString = WXApiManager.getRequestUrl("manKeep/checkPhone")
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: ["tgusetaccount":num,"checktype":"3"], successBlock: { (result) in
            print(result)
            MBProgressHUD.showSuccess("验证码已发送")
        }) { (error) in
            print(error)
        }
    }
    
}
