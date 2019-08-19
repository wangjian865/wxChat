//
//  WXPrivateViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXPrivateViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "隐私"
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WXWebViewController.init()
        if indexPath.row == 1{
            vc.title = "竹简服务协议"
        }else if indexPath.row == 2{
            vc.title = "隐私策略"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
