//
//  WXSettingTableViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXSettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func logoutAction(_ sender: UIButton) {
        MineViewModel.logoutRequest(success: { (msg) in
            WXAccountTool.logout()
            AppDelegate.sharedInstance()?.loginStateChange(false, huanxinID: "")
            self.navigationController?.popToRootViewController(animated: true)
        }) { (error) in
            
        }
    }
}
