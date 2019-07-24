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
        if indexPath.row == dataArray?.count{
            //设置加号
            cell.nameLabel.text = "加号"
            print("加号")
        }else if indexPath.row > dataArray?.count ?? 0{
            //设置减号
            cell.nameLabel.text = "减号"
            print("减号")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == dataArray?.count{
            //加号
            print("加号事件")
        }else if indexPath.row > dataArray?.count ?? 0{
            //减号
            print("减号事件")
        }
    }
}
