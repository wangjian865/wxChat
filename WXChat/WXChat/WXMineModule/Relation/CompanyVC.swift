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
    
    //用于push
    weak var superVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let sb = UIStoryboard.init(name: "RelationViewController", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "createCompanyVC")
            self?.superVC?.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.rowHeight = 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSection.contains(section){
            return datas[section].count
        } else {
            //不在showSection的组不展示cell
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UINib(nibName: "CompanyHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as! CompanyHeader
        header.companyInfo = "header数据"
        header.sectionIndex = section
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
            let vc = sb.instantiateViewController(withIdentifier: "editCompanyVC")
            self?.superVC?.navigationController?.pushViewController(vc, animated: true)
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendInfoCell", for: indexPath) as! FriendInfoCell
        cell.infoModel = datas[indexPath.section][indexPath.row]
        return cell
    }
    
}
