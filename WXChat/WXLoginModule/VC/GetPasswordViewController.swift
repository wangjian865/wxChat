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
        let urlString = "http://106.52.2.54:8080/SMIMQ/" + "manKeep/checkPhone"
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: ["tgusetaccount":num,"checktype":"3"], successBlock: { (result) in
            print(result)
        }) { (error) in
            print(error)
        }
    }
    
}
