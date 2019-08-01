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
    @IBOutlet weak var memberViewHeight: NSLayoutConstraint!
    
    var itemCount = 30//这里实际数据量应该是29   +1是加号按钮
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (UIScreen.main.bounds.width - 27*2 - 18*4)/5
        let height = width/67*84
        memberView.register(WXAddOrMinusCell.self, forCellWithReuseIdentifier: "memberCell")
        layout.itemSize = CGSize.init(width: width, height: height)
        
        let lines = (itemCount / 5) + ((itemCount % 5 > 0) ? 1 : 0)
        if lines > 4{
            memberViewHeight.constant = 10 + 5*height + 18*4
        }else{
            memberViewHeight.constant = 10 + height * CGFloat(lines) + 18 * CGFloat(lines-1)
        }
    }
    
    @IBAction func lookMoreAction(_ sender: Any) {
        
    }
    @IBAction func clearChatRecordAction(_ sender: Any) {
        
    }
    @IBAction func leaveGroupAction(_ sender: Any) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}
