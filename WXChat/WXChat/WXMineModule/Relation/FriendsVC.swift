//
//  RelationTableViewVCTableViewController.swift
//  login
//
//  Created by gwj on 2019/6/30.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class FriendsVC: UITableViewController {
  
    var datas = ["111","2222","33222","44222","55222","66222","77222","8222"]
    weak var superVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FriendInfoCell", bundle: nil), forCellReuseIdentifier: "FriendInfoCell")
        tableView.rowHeight = 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let personInfoView = WXUserMomentInfoViewController()
        superVC?.navigationController?.pushViewController(personInfoView, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendInfoCell", for: indexPath) as! FriendInfoCell
        cell.infoModel = datas[indexPath.row]
        return cell
    }
    
}
