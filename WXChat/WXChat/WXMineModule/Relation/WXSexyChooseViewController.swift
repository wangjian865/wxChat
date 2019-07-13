//
//  WXSexyChooseViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/8.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXSexyChooseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var selectIndex = 0
    lazy var tableV: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.bounces = false
        tableView.register(UINib.init(nibName: "WXSexyCell", bundle: nil), forCellReuseIdentifier: "sexyCell")
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableV)
        tableV.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sexyCell", for: indexPath) as! WXSexyCell
        if indexPath.row == 0{
            cell.nameLabel.text = "男"
        }else{
            cell.nameLabel.text = "女"
        }
        cell.isSelected = selectIndex == indexPath.row
        return cell
    }
}
