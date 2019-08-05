//
//  WXGroupSettingViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/27.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXGroupSettingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    

    @IBOutlet weak var memberView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var groupChatNameView: UIView!
    @IBOutlet weak var transforOwnerView: UIView!
    @IBOutlet weak var noDisturBtn: UISwitch!
    @IBOutlet weak var memberViewHeight: NSLayoutConstraint!
    
    var groupName = ""
    @objc var groupID: String?
    var users: [FriendModel]?
    
    var itemWidth:CGFloat = 0
    var itemCount = 30//这里实际数据量应该是29   +1是加号按钮
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (UIScreen.main.bounds.width - 27*2 - 18*4)/5
        let height = width/67*84
        itemWidth = width
        memberView.register(UINib.init(nibName: "WXAddOrMinusCell", bundle: nil), forCellWithReuseIdentifier: "groupmemberCell")
        layout.itemSize = CGSize.init(width: width, height: height)
        getUsers()
        let lines = (itemCount / 5) + ((itemCount % 5 > 0) ? 1 : 0)
        if lines > 4{
            memberViewHeight.constant = 10 + 5*height + 18*4
        }else{
            memberViewHeight.constant = 10 + height * CGFloat(lines) + 18 * CGFloat(lines-1)
        }
        addTargetForView()
    }
    func addTargetForView() {
        let groupTap = UITapGestureRecognizer.init(target: self, action: #selector(groupTapAction))
        groupChatNameView.addGestureRecognizer(groupTap)
        let ownerTap = UITapGestureRecognizer.init(target: self, action: #selector(changeOwnerAction))
        transforOwnerView.addGestureRecognizer(ownerTap)
    }
    @objc func groupTapAction() {
        let settingVC = WXSettingViewController()
        settingVC.title = "群聊名称"
        settingVC.callBackClosure = {[weak self] (result) in
            self?.groupName = result
        }
        navigationController?.pushViewController(settingVC, animated: true)
    }
    @objc func changeOwnerAction() {
        
    }
    func getUsers() {
        MineViewModel.getChatGroupUsers(groupId: groupID ?? "", success: { (result) in
            self.users = result;
            self.memberView.reloadData()
        }) { (error) in
            
        }
    }
    
    @IBAction func lookMoreAction(_ sender: Any) {
        
    }
    @IBAction func clearChatRecordAction(_ sender: Any) {
        
    }
    @IBAction func leaveGroupAction(_ sender: Any) {
        MineViewModel.leaveChatGroup(groupId: groupID ?? "", success: { (msg) in
            self.navigationController?.popToRootViewController(animated: true)
        }) { (error) in
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (users?.count ?? 0)+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupmemberCell", for: indexPath) as! WXAddOrMinusCell
        cell.iconView.cornerRadius = (itemWidth - 22)/2
        cell.backgroundColor = UIColor.yellow
        if indexPath.row == (users?.count ?? 0){
            //加号
            cell.nameLabel.text = ""
            cell.iconView.backgroundColor = UIColor.red
//            cell.iconView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: "加"))
            return cell
        }
        let model = users![indexPath.row];
        cell.iconView.sd_setImage(with: URL.init(string: model.tgusetimg))
        cell.nameLabel.text = model.tgusetname
        cell.deleteIcon.isHidden = true
        return cell
    }
}
