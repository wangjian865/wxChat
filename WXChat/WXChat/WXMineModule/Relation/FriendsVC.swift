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
    var models: [FriendModel]?
    weak var superVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FriendInfoCell", bundle: nil), forCellReuseIdentifier: "FriendInfoCell")
        tableView.rowHeight = 85
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        //WDX http
//        getFriendListRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFriendListRequest()
    }
    func getFriendListRequest() {
        MineViewModel.getFriendList(success: { (success) in
            self.models = success
            self.tableView.reloadData()
        }) { (error) in
            print("请求朋友列表失败")
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let personInfoView = WXUserMomentInfoViewController()
        let model = models?[indexPath.row]
        personInfoView.userId = model!.tgusetid
        superVC?.navigationController?.pushViewController(personInfoView, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendInfoCell", for: indexPath) as! FriendInfoCell
        cell.setModel(model: models![indexPath.row])
        return cell
    }
    
}
