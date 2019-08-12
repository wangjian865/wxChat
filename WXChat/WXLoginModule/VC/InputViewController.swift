//
//  InputViewController.swift
//  login
//
//  Created by gwj on 2019/6/18.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit
import SnapKit

enum PageType {
    case getPassword
    case confirm
    case register
//    case find
}

struct InputModel {
    var inputs = [InputInfo]()
}

struct InputInfo {
    var type: InputType = .account
    var title: String?
    var placeHolder: String?
}

class InputViewController: UIViewController {
    private var contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 18
        view.distribution = .fillEqually
        return view
    }()
    private var button = ZJButton()
    private var icon = UIImageView()
    private var remindLabel = UILabel()
    private var model: InputModel?
    var password = ""
    var account = ""
    var code = ""
    var type = PageType.getPassword {
        didSet {
            switch type {
            case .getPassword:
                let first = InputInfo(type: .account, title: nil, placeHolder: nil)
                let seconde = InputInfo(type: .verfication, title: nil, placeHolder: nil)
                model = InputModel(inputs: [first,seconde])
                button.setTitle("继续", for: .normal)
            case .confirm:
                let first = InputInfo(type: .password, title: nil, placeHolder: "输入新的密码")
                let seconde = InputInfo(type: .password, title: nil, placeHolder: "再次输入新的密码")
                model = InputModel(inputs: [first,seconde])
                button.setTitle("确定", for: .normal)
            case .register:
                let first = InputInfo(type: .account, title: nil, placeHolder: nil)
                let seconde = InputInfo(type: .verfication, title: nil, placeHolder: nil)
                let third = InputInfo(type: .password, title: "密     码", placeHolder: "密码由数字+字母组成")
                let forth = InputInfo(type: .password, title: "再次设置密码", placeHolder: "两次密码需要一致")
                
                model = InputModel(inputs: [first,seconde,third,forth])
                button.setTitle("注册", for: .normal)
            }
            createSubviews(model: model!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
    }
    
    //子类要重写的按钮点击方法
    func clickButton () {
        
    }
    @objc func getCode(num: String) {
        
    }
    
    @objc private func buttonAction() {
        clickButton()
    }
    
    private func setDefault() {
        view.backgroundColor = .white
        view.addSubview(contentView)
        view.addSubview(button)
        view.addSubview(icon)
        view.addSubview(remindLabel)
        button.isEnabled = false
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.greaterThanOrEqualTo(112)
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(47)
        }
        icon.snp.makeConstraints { (make) in
            make.height.width.equalTo(61)
            make.bottom.equalToSuperview().offset(-110)
            make.centerX.equalToSuperview()
        }
        icon.image = UIImage.init(named: "loginIcon");
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func createSubviews(model: InputModel) {
        for item in model.inputs {
            let inputView = ZJTextField.textFieldBy(data: item)
            if (item.type == .account){
                inputView.buttonClick = {[weak self] (num) in
                    //传出获取验证码事件
                    self?.getCode(num: num)
                }
            }
            contentView.addArrangedSubview(inputView)
            inputView.inputTextField.delegate = self
            inputView.inputTextField.addTarget(self, action: #selector(textFieldTextDidChange), for: UIControl.Event.editingChanged)
        }
    }
}

extension InputViewController: UITextFieldDelegate {
    
    //每个文本框有文字 那么登录按钮就可用
    @objc private func textFieldTextDidChange(textField: UITextField) {
        
        guard let _ = textField.text else {
            return
        }
        
        var list = [Bool]()
        for subview in contentView.arrangedSubviews {
            //判断是否有输入内容
            guard let item = subview as? ZJTextField, let text = item.inputTextField.text else {
                continue
            }
            if item.data?.type == .account {
                account = text
            }
            let isEnable = text.count > 0
            list.append(isEnable)
        }
        if list.first(where: {$0 == false}) != nil {
             button.isEnabled = false
        } else {
            //如果是密码验证，则两次密码需一致
            if type == .confirm{
                let inputFirst = contentView.arrangedSubviews.first as? ZJTextField
                let inputSecond = contentView.arrangedSubviews[1] as? ZJTextField
                if let pwd1 = inputFirst?.inputTextField.text,
                    let pwd2 = inputSecond?.inputTextField.text, pwd1 == pwd2 {
                    password = pwd1
                    button.isEnabled = true
                } else {
                    button.isEnabled = false
                    return
                }
            }
            if type == .register{
                
                let inputFirst = contentView.arrangedSubviews[2] as? ZJTextField
                let inputSecond = contentView.arrangedSubviews[3] as? ZJTextField
                if let pwd1 = inputFirst?.inputTextField.text,
                    let pwd2 = inputSecond?.inputTextField.text, pwd1 == pwd2 {
                    password = pwd1
                    button.isEnabled = true
                    code = (contentView.arrangedSubviews[1] as? ZJTextField)?.inputTextField.text ?? ""
                } else {
                    button.isEnabled = false
                    return
                }
            }
            if type == .getPassword{
//                let inputFirst = contentView.arrangedSubviews.first as? ZJTextField
                let inputSecond = contentView.arrangedSubviews[1] as? ZJTextField
                password = inputSecond?.inputTextField.text ?? ""
            }
                         button.isEnabled = true
        }
    }
}

