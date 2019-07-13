//
//  WXEditCompanyViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/6.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit


class WXEditCompanyViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑公司信息"
        
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
