//
//  WXEditPersonInfoViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/8.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXEditPersonInfoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let bottomView = Bundle.main.loadNibNamed("WXBottomChooseView", owner: nil, options: nil)?.first as! WXBottomChooseView
            bottomView.chooseClosure = {[weak self] (tag) in
                print(tag)
            }
            view.window?.addSubview(bottomView)
        }else if indexPath.row == 3{
            let sexyVC = WXSexyChooseViewController.init()
            navigationController?.pushViewController(sexyVC, animated: true)
        }else if indexPath.row == 2{
            let settingVC = WXSettingViewController()
            settingVC.title = "姓名"
            navigationController?.pushViewController(settingVC, animated: true)
        }else if indexPath.row == 4{
            let settingVC = WXSettingViewController()
            settingVC.title = "职位"
            navigationController?.pushViewController(settingVC, animated: true)
        }else if indexPath.row == 5{
            let settingVC = WXSettingViewController()
            settingVC.title = "公司"
            navigationController?.pushViewController(settingVC, animated: true)
        }
    }

}
