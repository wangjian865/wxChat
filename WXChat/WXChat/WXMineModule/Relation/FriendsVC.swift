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
        tableView.rowHeight = 75
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
            
            self.models = self.sortFriendList(list: success)
            self.tableView.reloadData()
        }) { (error) in
            print("请求朋友列表失败")
        }
        
    }
    //排序
    func sortFriendList(list: [FriendModel]) ->[FriendModel]?{
        return list.sorted(by: { (obj1,obj2) -> Bool in
            let firstLetter1 = EaseChineseToPinyin.pinyin(fromChineseString: obj1.tgusetname)
            let firstLetter2 = EaseChineseToPinyin.pinyin(fromChineseString: obj2.tgusetname)
            if let first1 = firstLetter1?.first?.uppercased(),let first2 = firstLetter2?.first?.uppercased(){
                let result = first1.caseInsensitiveCompare(first2)
                return result.rawValue == -1
            }
            return false
        })
//        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(SearchUserModel *obj1, SearchUserModel *obj2) {
//            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.tgusetName];
//            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
//
//            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.tgusetName];
//            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
//
//            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
//            }]
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
