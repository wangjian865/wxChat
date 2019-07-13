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
        
    }
    override func getCode(num: String) {
        let urlString = "http://106.52.2.54:8080/SMIMQ/" + "mankeep/checkphone"
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: ["tgusetaccount":num,"checktype":"1"], successBlock: { (result) in
            print("ssss")
        }) { (error) in
            print(error)
        }
    }
}
