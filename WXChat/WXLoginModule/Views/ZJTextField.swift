
//
//  ZJTextField.swift
//  login
//
//  Created by gwj on 2019/6/17.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

enum InputType {
    case account //输入手机号等，有三个控件
    case password //输入密码
    case verfication //验证码
    case input
}

class ZJTextField: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var verficationButton: VerficationButton!
    @IBOutlet weak var stackView: UIStackView!
    var buttonClick: (() -> ())?
    var data: InputInfo? {
        didSet {
            guard let data = data else {
                return
            }
            switch data.type {
            case .account:
                titleLabel.text = "手机号码"
                inputTextField.placeholder = "输入手机号"
            case .password:
                inputTextField.placeholder = data.placeHolder
                if let title = data.title {
                    titleLabel.text = title
                } else {
                    stackView.removeArrangedSubview(titleLabel)
                }
                stackView.removeArrangedSubview(verficationButton)
            case .verfication:
                titleLabel.text = "验 证 码"
                inputTextField.placeholder = "输入验证码"
                verficationButton.isHidden = true
                stackView.removeArrangedSubview(verficationButton)
            case .input:
                inputTextField.placeholder = data.placeHolder
                verficationButton.isHidden = true
                stackView.removeArrangedSubview(titleLabel)
                stackView.removeArrangedSubview(verficationButton)
            }
        }
    }

    static func textFieldBy(data: InputInfo) -> ZJTextField {
        let view = UINib(nibName: "ZJTextField", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as! ZJTextField
        view.data = data
        return view
    }
    
    @IBAction func getCode(_ sender: VerficationButton) {
        guard let num = inputTextField.text else {
            print("手机号码不能为空")
            return
        }
        if num.isTelNumber() {
            //发送验证码
        } else {
            print("不是手机号码")
            return
        }
        sender.isEnabled.toggle()
    }
}
