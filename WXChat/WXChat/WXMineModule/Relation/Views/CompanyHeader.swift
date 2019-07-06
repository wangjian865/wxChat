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
    var companyInfo = "" {
        didSet {
//            iconImageView.image = UIImage(named: <#T##String#>)
            companyLabel.text = "公司名字"
            descLabel.text = "公司描述"
            countLabel.text = "xx人"
        }
    }
    var tapCallBack: ((_ index: Int, _ isShow: Bool) -> ())?
    var tapEditCompany: ((_ model: String) -> ())?//string替换成某个模型
    var sectionIndex = 0
    //三角形图标旋转 默认分组收起
    var isShow = false {
        didSet {
            if isShow {
                UIView.animate(withDuration: 0.3, animations: {
                    self.arrowImageView.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi))
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
    
    @IBAction func editAction(_ sender: UIButton) {
        //编辑公司
        tapEditCompany?("旺旺公司")
    }
    
}
