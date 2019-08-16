
//
//  RelationHeaderView.swift
//  login
//
//  Created by gwj on 2019/6/26.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class RelationHeaderView: UIView {
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    //FIXME:根据信息赋值
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXib()
        iconImageView.sd_setImage(with: URL.init(string: WXAccountTool.getUserImage()), placeholderImage: UIImage.init(named: "normal_icon"))
        nameLabel.text = WXAccountTool.getUserName()
        positionLabel.text = WXAccountTool.getUserPosition()
        companyLabel.text = WXAccountTool.getUserXCompany()
    }
    
    public func initFromXib() {
        let nib = UINib(nibName: "RelationHeaderView", bundle: nil)
        headerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        headerView.frame = bounds
        addSubview(headerView)
    }
    func setContentData(model: UserInfoModel) {
        iconImageView.sd_setImage(with: URL.init(string: model.tgusetimg), placeholderImage: UIImage.init(named: "normal_icon"))
        nameLabel.text = model.tgusetname
        positionLabel.text = model.tgusetposition
        companyLabel.text = model.tgusetcompany
        
    }
}
