//
//  WXTwoBottomChooseView.swift
//  WXChat
//
//  Created by WX on 2019/7/14.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXTwoBottomChooseView: UIView {

    var chooseClosure: ((Int)->Void)?

    @objc @IBOutlet weak var firstBtn: UIButton!
    @objc @IBOutlet weak var secondBtn: UIButton!
    
    @IBAction func clickAction(_ sender: UIButton) {
        chooseClosure?(sender.tag)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.removeFromSuperview()
    }
}
