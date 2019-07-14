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
    let itemCount = 10
    override func awakeFromNib() {
        collectionView.register(UINib.init(nibName: "WXAddOrMinusCell", bundle: nil), forCellWithReuseIdentifier: "addOrMinusCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}
extension WXAddOrMinusView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addOrMinusCell", for: indexPath) as! WXAddOrMinusCell
        if indexPath.row == itemCount{
            //设置加号
            cell.nameLabel.text = "加号"
            print("加号")
        }else if indexPath.row > itemCount{
            //设置减号
            cell.nameLabel.text = "减号"
            print("减号")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == itemCount{
            //加号
            print("加号事件")
        }else if indexPath.row > itemCount{
            //减号
            print("减号事件")
        }
    }
}
