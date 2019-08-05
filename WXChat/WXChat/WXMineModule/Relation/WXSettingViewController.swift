//
//  WXSettingViewController.swift
//  WXChat
//
//  Created by WX on 2019/7/9.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXSettingViewController: UIViewController, UITextFieldDelegate {

    var textField = UITextField.init()
    
    var callBackClosure: ((String)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        textField.backgroundColor = UIColor.white
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.delegate = self
        
        view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.top.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(42)
        }
        let clearButton = UIButton.init(type: .custom)
        clearButton.setImage(UIImage.init(named: "取消"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearTF), for: .touchUpInside)
        view.addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.textField)
            make.right.equalTo(self.textField).offset(-12)
            make.width.height.equalTo(19)
        }
    }
    @objc func clearTF() {
        textField.text = ""
    }
    override func viewWillDisappear(_ animated: Bool) {
        callBackClosure?(textField.text ?? "")
        super.viewWillDisappear(animated)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
