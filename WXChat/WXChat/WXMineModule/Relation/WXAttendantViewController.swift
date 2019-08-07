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
    var dataArr: [SearchUserModel]?
    var contentView: WXAddOrMinusView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setNaviBar()
        setupUI()
        
        getdata()
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
            self.contentView.dataArray = adminModels
            self.contentView.collectionView.reloadData()
        }) { (error) in
            print("获取管理员失败")
        }
    }
    func getUserData() {
        MineViewModel.getCompanyUserList(companyid: companyID, success: { (friendModels) in
            self.dataArr = friendModels
            self.contentView.dataArray = friendModels
            self.contentView.collectionView.reloadData()
        }) { (error) in
            print("获取成员失败")
        }
    }
    func setNaviBar() {
        let button = UIButton.init(type: .custom)
        button.setTitle("保存", for: .normal)
        button.frame.size = CGSize.init(width: 52, height: 28)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 2
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.layer.borderColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor
        button.layer.borderWidth = 0.5;
        button.addTarget(self, action: #selector(checkOutAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
    }
    
    //记录去掉的用户id
    var deleteUserIDs: [SearchUserModel] = []
    //确认按钮
    @objc func checkOutAction() {
        contentView.isEdit = false
        contentView.collectionView.reloadData()
        if deleteUserIDs.count > 0{
            deleteRequest()
        }
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
        var deleteStr = ""
        for model in deleteUserIDs {
            deleteStr = deleteStr + model.tgusetId + ","
        }
        deleteStr.removeLast()
        MineViewModel.deleCompanyUser(companysystem: deleteStr, companyid: companyID, success: { (success) in
            self.getdata()
        }) { (error) in
            print("删除公司用户失败")
        }
    }
    func deleteAdminRequest() {
        var deleteStr = ""
        for model in deleteUserIDs {
            deleteStr = deleteStr + model.tgusetId + ","
        }
        deleteStr.removeLast()
        MineViewModel.deleCompanyAdmin(tgusetids: deleteStr, seanceshowidadmincompanyid: companyID, success: { (success) in
            self.getdata()
        }) { (error) in
            print("删除公司管理员失败")
        }
    }
    func setupUI() {
        let tempView = Bundle.main.loadNibNamed("WXAddOrMinusView", owner: nil, options: nil)?.last as! WXAddOrMinusView
        tempView.addClosure = {[weak self] in
            let vc = WXUsersListViewController.init()
            vc.chooseCompletion = { (IDs) in
                let ids = IDs.joined(separator: ",")
                if (self?.title == "管理员设置"){
                    MineViewModel.addCompanyAdmin(tgusetids: ids, seanceshowidadmincompanyid: self?.companyID ?? "", success: { (success) in
                        self?.getdata()
                        
                    }, failure: { (error) in
                        print("添加管理员失败")
                    })
                }else{//成员设置
                    MineViewModel.addCompanyUser(companytgusettgusetids: ids, companytgusetcompanyid: self?.companyID ?? "", success: { (success) in
                        self?.getdata()
                    }, failure: { (error) in
                        print("添加成员失败")
                    })
                }
                
            }
            vc.isEditing = true
            vc.isGroup = false
            let nav = WXPresentNavigationController.init(rootViewController: vc)
            self?.present(nav, animated: true, completion: nil)
        }
        tempView.deleteClosure = { [weak self] model in
            
            if (self?.deleteUserIDs.contains(model))!{
                    self?.deleteUserIDs.removeAll(where: { (temp) -> Bool in
                        return temp == model
                    })
                }else{
                    self?.deleteUserIDs.append(model)
                    print(self?.deleteUserIDs.count)
                }
        }
        contentView = tempView
        tempView.dataArray = dataArr
        tempView.titleLabel.text = title
        view.addSubview(tempView)
        tempView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
    }
    
}
