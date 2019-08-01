//
//  CompanyHeader.swift
//  login
//
//  Created by gwj on 2019/7/1.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class CompanyHeader: UIView {
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    //arrowImageView的imgage以及编辑按钮的图标 需要替换成正确的图
    var myModel: CompanyModel?
    var tapCallBack: ((_ index: Int, _ isShow: Bool) -> ())?
    var tapEditCompany: ((_ model: CompanyModel) -> ())?//string替换成某个模型
    var sectionIndex = 0
    //三角形图标旋转 默认分组收起
    var isShow = false {
        didSet {
            if isShow {
                UIView.animate(withDuration: 0.3, animations: {
                    self.arrowImageView.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi/2))
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.arrowImageView.transform = CGAffineTransform.identity.rotated(by: 0)
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        isShow.toggle()
        tapCallBack?(sectionIndex,isShow)
    }
    func setContentData(model: CompanyModel){
        myModel = model
        companyLabel.text = model.companyname
        iconImageView.sd_setImage(with: URL.init(string: model.companylogo), placeholderImage: UIImage.init(named: "normal_icon"))
        descLabel.text = model.companysynopsis
        countLabel.text = model.companycount + "人"
    }
    @IBAction func editAction(_ sender: UIButton) {
        //编辑公司
        tapEditCompany?(myModel!)
    }
    
}
