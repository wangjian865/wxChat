//
//  WXBottomChooseView.swift
//  WXChat
//
//  Created by WX on 2019/7/8.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXBottomChooseView: UIView {
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    var chooseClosure: ((Int)->Void)?
    override func awakeFromNib() {
        
    }
    @IBAction func chooseAction(_ sender: UIButton) {
        removeFromSuperview()
        chooseClosure?(sender.tag)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        removeFromSuperview()
    }

    func setShowData(array: [String]) {
        firstBtn.setTitle(array[0], for: .normal)
        secondBtn.setTitle(array[1], for: .normal)
        thirdBtn.setTitle(array[2], for: .normal)
    }
}
