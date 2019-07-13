//
//  ZJButton.swift
//  login
//
//  Created by gwj on 2019/6/17.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class ZJButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = UIColor(red: 48.0 / 255.0, green: 134.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
            } else {
                backgroundColor = .gray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        defaultSet()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultSet()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSet()
    }
    
    private func defaultSet() {
        cornerRadius = 6
        clipsToBounds = true
        backgroundColor = .blue
    }

}
