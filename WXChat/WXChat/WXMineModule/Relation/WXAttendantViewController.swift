//
//  WXAttendantViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXAttendantViewController: UIViewController {
    var companyID = ""
    ///供选的数组
    var chooseArr: [SearchUserModel] = []
    ///展示的数组
    var dataArr: [SearchUserModel]?
    var contentView: WXAddOrMinusView!
//  返回的id数组
    var IDs: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
//        setNaviBar()
        setupUI()
        getdata()
        getChooseData()
    }
    func getdata() {
        if (self.title == "管理员设置"){
            getAdminData()
        }else{
            getUserData()
        }
    }
    func getAdminData() {
        MineViewModel.getCompanyAdminList(companyid: companyID, success: { (adminModels) in
            self.dataArr = adminModels
            self.getIDs()
            self.contentView.dataArray = adminModels
            self.contentView.collectionView.reloadData()
        }) { (error) in
            print("获取管理员失败")
        }
    }
    func getUserData() {
        MineViewModel.getCompanyUserList(companyid: companyID, success: { (friendModels) in
            self.dataArr = friendModels
            self.getIDs()
            self.contentView.dataArray = friendModels
            self.contentView.collectionView.reloadData()
            
        }) { (error) in
            print("获取成员失败")
        }
    }
    func getIDs() {
        IDs.removeAll()
        if let data = dataArr{
            for temp in data {
                IDs.append(temp.tgusetId)
            }
        }
    }
    func getChooseData(){
        if (self.title == "管理员设置"){
            MineViewModel.getCompanyUserList(companyid: companyID, success: { (friendModels) in
                if let temp = friendModels{
                    self.chooseArr = temp
                }
            }) { (error) in
                print("获取成员失败")
            }
        }else{
            MineViewModel.getFriendList(success: { (friendList) in
                self.chooseArr.removeAll()
                for friend in friendList {
                    let temp = SearchUserModel()
                    temp.tgusetImg = friend.tgusetimg
                    temp.tgusetId = friend.tgusetid
                    temp.tgusetAccount = friend.tgusetaccount
                    temp.tgusetName = friend.tgusetname
                    self.chooseArr.append(temp)
                }
            }) { (error) in
                print("获取好友列表失败")
            }
        }
    }
    
    //记录去掉的用户id
    var deleteUserIDs: [String] = []
    //确认按钮
    @objc func checkOutAction() {
        deleteRequest()
    }
    //添加操作
    func addRequest() {
        if (self.title == "管理员设置"){
            addAdminRequest()
        }else{
            addUserRequest()
        }
        deleteUserIDs.removeAll()
    }
    func addAdminRequest() {
        let addStr = deleteUserIDs.joined(separator: ",")
        MineViewModel.addCompanyAdmin(tgusetids: addStr, seanceshowidadmincompanyid: self.companyID , success: { (success) in
            self.getdata()
        }, failure: { (error) in
            print("添加管理员失败")
        })
    }
    func addUserRequest() {
        let addStr = deleteUserIDs.joined(separator: ",")
        MineViewModel.addCompanyUser(companytgusettgusetids: addStr, companytgusetcompanyid: self.companyID, success: { (success) in
            self.getdata()
        }, failure: { (error) in
            print("添加成员失败")
        })
    }
    //删除操作
    func deleteRequest() {
        if (self.title == "管理员设置"){
            deleteAdminRequest()
        }else{
            deleteUserRequest()
        }
        deleteUserIDs.removeAll()
    }
    func deleteUserRequest() {
        let deleteStr = deleteUserIDs.joined(separator: ",")
        MineViewModel.deleCompanyUser(companysystem: deleteStr, companyid: companyID, success: { (success) in
            self.getdata()
        }) { (error) in
            print("删除公司用户失败")
        }
    }
    func deleteAdminRequest() {

//        for model in deleteUserIDs {
//            deleteStr = deleteStr + model.tgusetId + ","
//        }
//        deleteStr.removeLast()
        let deleteStr = deleteUserIDs.joined(separator: ",")
        MineViewModel.deleCompanyAdmin(tgusetids: deleteStr, seanceshowidadmincompanyid: companyID, success: { (success) in
            self.getdata()
        }) { (error) in
            print("删除公司管理员失败")
        }
    }
    func setupUI() {
        let tempView = Bundle.main.loadNibNamed("WXAddOrMinusView", owner: nil, options: nil)?.last as! WXAddOrMinusView
//        tempView.addClosure = {[weak self] in
//            let vc = WXUsersListViewController.init()
//            vc.hasIDs = self!.IDs
//            vc.chooseCompletion = { (IDs) in
//                let ids = IDs.joined(separator: ",")
//                if (self?.title == "管理员设置"){
//                    MineViewModel.addCompanyAdmin(tgusetids: ids, seanceshowidadmincompanyid: self?.companyID ?? "", success: { (success) in
//                        self?.getdata()
//
//                    }, failure: { (error) in
//                        print("添加管理员失败")
//                    })
//                }else{//成员设置
//                    MineViewModel.addCompanyUser(companytgusettgusetids: ids, companytgusetcompanyid: self?.companyID ?? "", success: { (success) in
//                        self?.getdata()
//                    }, failure: { (error) in
//                        print("添加成员失败")
//                    })
//                }
//
//            }
//            vc.isEditing = true
//            vc.isGroup = false
//            let nav = WXPresentNavigationController.init(rootViewController: vc)
//            self?.present(nav, animated: true, completion: nil)
//        }
        //add
        tempView.addClosure = { [weak self] in
            let vc = WDXUserListViewController()
            vc.chooseCompletion = { [weak self](idArray) in
                self?.deleteUserIDs = idArray
                self?.addRequest()
            }
            vc.users = self!.chooseArr
            vc.selectedIDS = self!.IDs
            vc.rightTitle = "添加"
            let nav = WXPresentNavigationController.init(rootViewController: vc)
            self?.present(nav, animated: true, completion: nil)
        }
        //delete
        tempView.newDeleteClosure = { [weak self] in
            let vc = WDXUserListViewController()
            vc.chooseCompletion = { [weak self](idArray) in
                self?.deleteUserIDs = idArray
                self?.deleteRequest()
            }
            if let temp = self?.dataArr {
                vc.users = temp
            }
            vc.rightTitle = "移除"
            let nav = WXPresentNavigationController.init(rootViewController: vc)
            self?.present(nav, animated: true, completion: nil)
        }
        contentView = tempView
        tempView.parents = self
        tempView.dataArray = dataArr
        tempView.titleLabel.text = title
        view.addSubview(tempView)
        tempView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
    }
    
}
