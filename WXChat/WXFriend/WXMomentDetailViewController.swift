//
//  WXMomentDetailViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/16.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXMomentDetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var imageArr: [String]?
    @objc var model: FriendMomentInfo?
    var myModel: Enterprise?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib.init(nibName: "WXFriendMomentImageCell", bundle: nil), forCellWithReuseIdentifier: "collCell")
        tableView.register(UINib.init(nibName: "WXSexyCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        tableView.rowHeight = 40
        collectionHeight.constant = 111
        tableViewHeight.constant = 120
        getMomentDetailInfo()
    }
    func getMomentDetailInfo() {
        CompanyViewModel.getMomentsDetail(withPriseid: model!.enterprisezid, successBlock: { (detailModel) in
            self.myModel = detailModel
            self.iconView.sd_setImage(with: URL.init(string: detailModel.tgusetImg))
            self.nameLabel.text = detailModel.tgusetName
            self.companyLabel.text = detailModel.tgusetCompany
            self.timeLabel.text = Utility.getMomentTime(detailModel.enterprisezTime)
            let array = detailModel.enterprisezfujina.components(separatedBy: ",")
            self.imageArr = array
            var line = array.count / 3
            if array.count % 3 > 0{
                line = line + 1
            }
            self.collectionHeight.constant = CGFloat((28 + 11 * (line - 1) + 111 * line))
            self.collectionView.reloadData()
        }) { (error) in
            
        }
    }

}
extension WXMomentDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! WXFriendMomentImageCell
        let urlStr = imageArr![indexPath.row]
        cell.backgroundColor = UIColor.blue
        cell.myImageView.sd_setImage(with: URL.init(string: urlStr))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.backgroundColor = UIColor.yellow
        return cell
    }
}
