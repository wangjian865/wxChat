//
//  WXSettingTableViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXSettingTableViewController: UITableViewController {

    @IBOutlet weak var newsPushSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        newsPushSwitch.isOn = !(WXAccountTool.getDisturbState())
        newsPushSwitch.addTarget(self, action: #selector(changeDisturbState), for: .valueChanged)
    }
    @objc func changeDisturbState(_ aSwitch: UISwitch) {
        
        UserDefaults.standard.set(!(aSwitch.isOn), forKey: "disturbState")
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
