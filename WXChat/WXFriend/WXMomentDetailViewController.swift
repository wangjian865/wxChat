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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collCell")
        tableView.register(UINib.init(nibName: "WXSexyCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        tableView.rowHeight = 40
        collectionHeight.constant = 111
        tableViewHeight.constant = 120
    }
    

}
extension WXMomentDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath)
        cell.backgroundColor = UIColor.blue
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
