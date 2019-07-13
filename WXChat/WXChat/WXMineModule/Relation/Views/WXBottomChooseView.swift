//
//  WXBottomChooseView.swift
//  WXChat
//
//  Created by WX on 2019/7/8.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXBottomChooseView: UIView {
    
    var chooseClosure: ((Int)->Void)?
    override func awakeFromNib() {
        
    }
    @IBAction func chooseAction(_ sender: UIButton) {
        chooseClosure?(sender.tag)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        removeFromSuperview()
    }
    func setShowData(array: [String]) {
        
    }
}
