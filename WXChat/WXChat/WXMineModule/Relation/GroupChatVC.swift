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
    weak var superVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ChatGroupCell", bundle: nil), forCellReuseIdentifier: "ChatGroupCell")
        tableView.rowHeight = 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupCell", for: indexPath) as! ChatGroupCell
        cell.groupModel = datas[indexPath.row]
        return cell
    }
}
