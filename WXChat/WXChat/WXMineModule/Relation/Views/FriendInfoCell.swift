//
//  FriendInfoCell.swift
//  login
//
//  Created by gwj on 2019/6/30.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class FriendInfoCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    //改成实际模型，并赋值
    var infoModel = "" {
        didSet {
//            iconImageView.image = UIImage(named: <#T##String#>)
            nameLabel.text = infoModel
            positionLabel.text = "职位"
            companyLabel.text = "公司名字"
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
