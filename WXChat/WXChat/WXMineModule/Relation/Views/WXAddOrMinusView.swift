//
//  WXAddOrMinusView.swift
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXAddOrMinusView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var parents: UIViewController?
    var isEdit = false
    var addClosure: (()-> Void)?
    var newDeleteClosure: (()-> Void)?
    
    var dataArray: [SearchUserModel]?
    override func awakeFromNib() {
        collectionView.register(UINib.init(nibName: "WXAddOrMinusCell", bundle: nil), forCellWithReuseIdentifier: "addOrMinusCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}
extension WXAddOrMinusView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataArray?.count ?? 0) + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addOrMinusCell", for: indexPath) as! WXAddOrMinusCell
        if indexPath.row == dataArray?.count ?? 0{
            //设置加号
            cell.nameLabel.text = ""
            cell.deleteIcon.isHidden = true
            cell.iconView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: "加"))
            
        }else if indexPath.row > dataArray?.count ?? 0{
            //设置减号
            cell.nameLabel.text = ""
            cell.deleteIcon.isHidden = true
            cell.iconView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: "减"))
            
        }else{
            if let data = dataArray{
               let model = data[indexPath.item]
               cell.nameLabel.text = model.tgusetName
                cell.iconView.sd_setImage(with: URL.init(string: model.tgusetImg), placeholderImage: UIImage.init(named: "normal_icon"))
                
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == dataArray?.count ?? 0{
            //加号
            
            addClosure?()
        }else if indexPath.row > dataArray?.count ?? 0{
            //减号
            newDeleteClosure?()
        }else{
            if let data = dataArray{
                let model = data[indexPath.item]
                let userID = model.tgusetId
                if userID == WXAccountTool.getUserID(){
                    let infoVC = WXUserMomentInfoViewController.init()
                    infoVC.userId = userID
                    parents?.navigationController?.pushViewController(infoVC, animated: true)
                }else{
                    MineViewModel.judgeIsFriend(friendID: userID, success: { (msg) in
                        if let temp = msg,temp == "是"{
                            let infoVC = WXUserMomentInfoViewController.init()
                            infoVC.userId = userID
                            self.parents?.navigationController?.pushViewController(infoVC, animated: true)
                        }else{
                            MineViewModel.getUserInfo(userID, success: { (model) in
                                let resultVC = WXfriendResultViewController()
                                resultVC.model = model ?? UserInfoModel()
                                self.parents?.navigationController?.pushViewController(resultVC, animated: true)
                            }, failure: { (error) in
                                
                            })
                        }
                    }) { (error) in
                        
                    }
                }
            }
            
        }
        
    }
}
