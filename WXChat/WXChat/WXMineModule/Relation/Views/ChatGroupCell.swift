//
//  ChatGroupCell.swift
//  login
//
//  Created by gwj on 2019/6/30.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class ChatGroupCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var groupModel: GroupModel?{
        didSet {
//            iconImage.sd_setImage(with: URL.init(string:groupModel. ))
            nameLabel.text = groupModel?.seanceshowname
            messageLabel.text = "聊天聊天"
            timeLabel.text = "时间"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
