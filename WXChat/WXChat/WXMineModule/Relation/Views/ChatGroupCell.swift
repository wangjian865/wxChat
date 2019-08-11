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
            
//            DispatchQueue.global().async {
                var iconUrls: [URL] = []
                if let users = self.groupModel?.tgusets{
                    for model in users{
                        if let url = URL.init(string: model.tgusetimg){
                            iconUrls.append(url)
                        }
                    }
                }
//                let image = UIImage.groupIcon(withURLArray: iconUrls, bgColor: UIColor.lightGray)
//                DispatchQueue.main.async {
//                    self.iconImage.image = image
//                }
//            }
            if iconUrls.count == 1{
                self.iconImage.sd_setImage(with: iconUrls.first);
            }else{
                UIImage.groupIcon(withURLArray: iconUrls, bgColor: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)) { (groupIcon) in
                    self.iconImage.image = groupIcon
                }
            }
            
            nameLabel.text = groupModel?.seanceshowname

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
