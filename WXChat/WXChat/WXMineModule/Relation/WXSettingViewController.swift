//
//  WXSettingViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/9.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXSettingViewController: UIViewController {

    var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        textField = UITextField.init()
        textField.backgroundColor = UIColor.white
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 10))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.top.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(42)
        }
        let clearButton = UIButton.init(type: .custom)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        clearButton.setTitle("❎", for: .normal)
        clearButton.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.textField)
            make.right.equalTo(self.textField).offset(-12)
            make.width.height.equalTo(19)
        }
    }
    
}
