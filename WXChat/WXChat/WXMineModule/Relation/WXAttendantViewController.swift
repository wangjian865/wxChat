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
        if (self.title == "管理员设置"){
            getAdminData()
        }
        
    }
    func getAdminData() {
        MineViewModel.getCompanyAdminList(companyid: companyID, success: { (adminModels) in
            print("1")
        }) { (error) in
            print("获取管理员失败")
        }
    }
    func getUserData() {
        MineViewModel.getCompanyUserList(companyid: companyID, success: { (friendModels) in
            print("2")
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
    //确认按钮
    @objc func checkOutAction() {
//        let urlString = "http://106.52.2.54:8080/SMIMQ/" + "manKeepToken/findUserAccount"
//        let account = UserDefaults.standard.string(forKey: "account")
//        let params:[String:String] = ["tgusetaccount":account ?? ""]
//        
//        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
//            
//            let model = UserInfoModel.yy_model(with: result as! [AnyHashable : Any])
//            print(result)
//        }) { (error) in
//            
//            print(error)
//        }
        
    }
    func setupUI() {
        let tempView = Bundle.main.loadNibNamed("WXAddOrMinusView", owner: nil, options: nil)?.last as! WXAddOrMinusView
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
