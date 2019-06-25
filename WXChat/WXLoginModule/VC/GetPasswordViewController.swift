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
    }
    
    override func clickButton() {
        print(account)
        //        FIXME:校验验证码
        let vc = ConfirmViewController()
        vc.account = account
        navigationController?.pushViewController(vc, animated: true)
    }
}
