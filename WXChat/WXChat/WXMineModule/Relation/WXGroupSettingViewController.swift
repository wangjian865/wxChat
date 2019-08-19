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
    @IBOutlet weak var lookForMoreViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var memberViewHeight: NSLayoutConstraint!
    
    var groupName = ""
    @objc var groupID: String?
    var users: [FriendModel]?
    
    var itemWidth:CGFloat = 0
    var itemHeight:CGFloat = 0
    var itemCount = 30//这里实际数据量应该是29   +1是加号按钮
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "群聊设置"
        let width = (UIScreen.main.bounds.width - 27*2 - 18*4)/5
        let height = width/67*84
        itemWidth = width
        itemHeight = height
        memberView.register(UINib.init(nibName: "WXAddOrMinusCell", bundle: nil), forCellWithReuseIdentifier: "groupmemberCell")
        layout.itemSize = CGSize.init(width: width, height: height)
        getUsers()
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
            MineViewModel.renameChatGroup(managerID: WXAccountTool.getUserID(), groupName: result, groupId: self?.groupID ?? "", success: { (msg) in
                MBProgressHUD.showSuccess(msg)
                
            }, failure: { (error) in
                
            })
        }
        navigationController?.pushViewController(settingVC, animated: true)
    }
    @objc func changeOwnerAction() {
        let vc = WXUsersListViewController.init()
        vc.cardCallBack = {[weak self] ID in
            MineViewModel.changeOwner(groupID: self?.groupID ?? "", newOwnerID: ID, success: { (msg) in
                self?.getUsers()
                MBProgressHUD.showSuccess(msg)
            }, failure: { (error) in
                
            })
        }
        
        vc.isEditing = true
        vc.isInfoCard = true
        let nav = WXPresentNavigationController.init(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    ///request
    func getUsers() {
        MineViewModel.getChatGroupUsers(groupId: groupID ?? "", success: { (result) in
            self.users = result;
            self.memberView.reloadData()
            self.setCollectionViewHeight()
        }) { (error) in
            
        }
        MineViewModel.getGroupAdmin(groupID: groupID ?? "", success: { (adminID) in
            if adminID == WXAccountTool.getUserID(){
                self.groupChatNameView.isHidden = false
                self.transforOwnerView.isHidden = false
            }else{
                self.groupChatNameView.isHidden = true
                self.transforOwnerView.isHidden = true
            }
        }) { (error) in
            
        }
    }
    func setCollectionViewHeight() {
        let count = (users?.count ?? 0) + 1
        let lines = (count / 5) + ((count % 5 > 0) ? 1 : 0)
        if lines > 4{
            memberViewHeight.constant = 10 + 5*itemHeight + 18*4
            lookForMoreViewHeight.constant = 70
        }else{
            lookForMoreViewHeight.constant = 0
            memberViewHeight.constant = 10 + itemHeight * CGFloat(lines) + 18 * CGFloat(lines-1)
        }
    }
    @IBAction func clearChatRecordAction(_ sender: Any) {
        WXChatService.deleteAConversation(withId: groupID ?? "") { (msg, error) in
            MBProgressHUD.showSuccess("聊天记录已清空")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func leaveGroupAction(_ sender: Any) {
        WXChatService.deleteAConversation(withId: groupID ?? "") { (msg, error) in
        }
        MineViewModel.leaveChatGroup(groupId: groupID ?? "", success: { (msg) in
            self.navigationController?.popToRootViewController(animated: true)
        }) { (error) in

        }
    }
    @IBAction func lookForMoreAction(_ sender: Any) {
        lookForMoreViewHeight.constant = 0
        let count = (users?.count ?? 0) + 1
        let lines = (count / 5) + ((count % 5 > 0) ? 1 : 0)
        memberViewHeight.constant = 10 + itemHeight * CGFloat(lines) + 18 * CGFloat(lines-1)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (users?.count ?? 0)+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupmemberCell", for: indexPath) as! WXAddOrMinusCell
        cell.iconView.cornerRadius = (itemWidth - 22)/2
        if indexPath.row == (users?.count ?? 0){
            //加号
            cell.nameLabel.text = ""
            cell.iconView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: "加"))
            return cell
        }
        let model = users![indexPath.row];
        cell.iconView.sd_setImage(with: URL.init(string: model.tgusetimg))
        cell.nameLabel.text = model.tgusetname
        cell.deleteIcon.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == (users?.count ?? 0){
            //邀请新人入群聊
            let vc = WXUsersListViewController.init()
            vc.chooseCompletion = { (IDs) in
                MineViewModel.addGroupMember(groupID: self.groupID ?? "", users: IDs, success: { (msg) in
                    MBProgressHUD.showSuccess(msg)
                    if ((msg?.contains("已在群里"))!){
                        return
                    }
                    self.getUsers()
                }, failure: { (error) in
                    
                })
            }
            vc.isEditing = true
            vc.isGroup = false
            if let temps = users{
                var temp: [String] = []
                for user in temps {
                    temp.append(user.tgusetid)
                }
                vc.hasIDs = temp
            }
            let nav = WXPresentNavigationController.init(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        }else{
            
            let model = users![indexPath.row]
            let userID = model.tgusetid
            if userID == WXAccountTool.getUserID(){
                let infoVC = WXUserMomentInfoViewController.init()
                infoVC.userId = userID
                self.navigationController?.pushViewController(infoVC, animated: true)
            }else{
                MineViewModel.judgeIsFriend(friendID: userID, success: { (msg) in
                    if let temp = msg,temp == "是"{
                        let infoVC = WXUserMomentInfoViewController.init()
                        infoVC.userId = userID
                        self.navigationController?.pushViewController(infoVC, animated: true)
                    }else{
                        MineViewModel.getUserInfo(userID, success: { (model) in
                            let resultVC = WXfriendResultViewController()
                            resultVC.model = model ?? UserInfoModel()
                            self.navigationController?.pushViewController(resultVC, animated: true)
                        }, failure: { (error) in
                            
                        })
                    }
                }) { (error) in
                    
                }
            }
            
            
        }
    }
}
