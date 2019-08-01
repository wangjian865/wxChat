//
//  ConpanyVC.swift
//  login
//
//  Created by gwj on 2019/6/30.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class CompanyVC: UITableViewController {
    var datas =  [["111","2222","33222","44222"],["55222","66222","77222"],["8222"]]
    var showSection = [Int]()
    var companymodels: [CompanyModel]?
    //用于push
    weak var superVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        initMyView()
        initMyData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initMyData()
    }
    func initMyView() {
        tableView.register(UINib(nibName: "FriendInfoCell", bundle: nil), forCellReuseIdentifier: "FriendInfoCell")
        tableView.register(UINib(nibName: "CompanyHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CompanyHeader")
        
        let footer = UINib(nibName: "CompanyFooter", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CompanyFooter
        footer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500)
        tableView.tableFooterView = footer
        footer.createActionClosure = {[weak self] in
            let sb = UIStoryboard.init(name: "RelationViewController", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "createCompanyVC")
            self?.superVC?.navigationController?.pushViewController(vc, animated: true)
        }
        footer.joinActionClosure = {[weak self] in
            let vc = WXAddCompanyViewController()
            self?.superVC?.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.rowHeight = 85
    }
    func initMyData() {
        MineViewModel.searchUserCompanys(success: { (success) in
            self.companymodels = success
            self.tableView.reloadData()
        }) { (error) in
            print("获取公司列表失败")
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let personInfoView = WXUserMomentInfoViewController()
        let companyModel = companymodels![indexPath.section]
        let model = companyModel.users[indexPath.row]
        personInfoView.userId = model.tgusetid
        superVC?.navigationController?.pushViewController(personInfoView, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSection.contains(section){
            return companymodels![section].users.count
        } else {
            //不在showSection的组不展示cell
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return companymodels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UINib(nibName: "CompanyHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as! CompanyHeader
        let model = companymodels![section]
        header.sectionIndex = section
        header.setContentData(model: model)
        if showSection.contains(section) {
            header.isShow = true
        }
        header.tapCallBack = {[weak self](sectionIndex,isShow) in
            if isShow {
                self?.showSection.append(sectionIndex)
            } else {
                if let idx = self?.showSection.firstIndex(of: sectionIndex) {
                    self?.showSection.remove(at: idx)
                }
            }
            self?.tableView.reloadData()
        }
        header.tapEditCompany = {[weak self] (model) in
            let sb = UIStoryboard.init(name: "RelationViewController", bundle: nil)

            let vc = sb.instantiateViewController(withIdentifier: "editCompanyVC")  as! WXEditCompanyViewController
            vc.setContentData(model: model)
            self?.superVC?.navigationController?.pushViewController(vc, animated: true)
        }
        return header
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        return view
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendInfoCell", for: indexPath) as! FriendInfoCell
        let companyModel = companymodels![indexPath.section]
        let model = companyModel.users[indexPath.row]
        cell.setModel(model: model)
//        cell.infoModel = datas[indexPath.section][indexPath.row]
        return cell
    }
    
}
