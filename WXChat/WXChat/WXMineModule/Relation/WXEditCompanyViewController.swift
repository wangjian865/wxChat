//
//  WXEditCompanyViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/6.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit
import XLActionController

class WXEditCompanyViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑公司信息"
        
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let action = TweetbotActionController()
//        actionController.addAction(Action("Take photo", style: .default, handler: { action in
//        }))
//        actionController.addAction(Action("Choose existing photo", style: .default, handler: { action in
//        }))
//        actionController.addAction(Action("Remove profile picture", style: .default, handler: { action in
//        }))
//        actionController.addAction(Action("Cancel", style: .cancel, handler: nil))
//        
//        present(actionController, animated: true, completion: nil)
    }
}
