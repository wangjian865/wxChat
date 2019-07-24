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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setModel(model: FriendModel){
        iconImageView.sd_setImage(with: URL.init(string: model.tgusetimg), placeholderImage: UIImage.init(named: "normal_icon"))
        nameLabel.text = model.tgusetname
        positionLabel.text = model.tgusetposition
        companyLabel.text = model.tgusetcompany
    }
}
