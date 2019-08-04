//
//  GroupChatVC.swift
//  login
//
//  Created by gwj on 2019/6/30.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class GroupChatVC: UITableViewController {

    var datas = ["111","2222","33222","44222","55222","66222","77222","8222"]
    var listModel: GroupListModel?
    weak var superVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ChatGroupCell", bundle: nil), forCellReuseIdentifier: "ChatGroupCell")
        tableView.rowHeight = 90
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getdata()
    }
    func getdata() {
        MineViewModel.getChatGroupList(success: { (model) in
            self.listModel = model
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let settingVC = WXGroupSettingViewController.init()
//        superVC?.navigationController?.pushViewController(settingVC, animated: true)
        let model = listModel?.data[indexPath.row]
        let chatVC = WXChatViewController.init(conversationChatter: model?.seanceshowid ?? "", conversationType: EMConversationTypeGroupChat)
        chatVC?.title = model?.seanceshowname ?? ""
        superVC?.navigationController?.pushViewController(chatVC!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel?.data.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupCell", for: indexPath) as! ChatGroupCell
        cell.groupModel = listModel?.data[indexPath.row]
        return cell
    }
}
