//
//  WXSexyCell.swift
//  WXChat
//
//  Created by WX on 2019/7/9.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXSexyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexyIcon: UIImageView!
    @IBOutlet weak var selectIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectIcon.isHidden = !selected
        //同时改变字体颜色和图片
    }
    
}
