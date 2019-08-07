//
//  RelationSearchView.swift
//  login
//
//  Created by gwj on 2019/6/28.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class RelationSearchView: UIView {
    var clickAction: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchAction))
        addGestureRecognizer(tap)
    }
    
    @objc func searchAction() {
        clickAction?()
    }
}
