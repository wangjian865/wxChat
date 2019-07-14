//
//  ZJLoginView.swift
//  login
//
//  Created by gwj on 2019/6/17.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit
enum LoginType {
    case password
    case verficationCode
}

class ZJLoginView: UIView {
    @IBOutlet var loginView: UIView!
    @IBOutlet private weak var accountView: UIView!
    @IBOutlet private weak var accountLabel: UILabel!
    @IBOutlet private weak var accountTextField: UITextField!
    @IBOutlet private weak var verfiButton: VerficationButton!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var verfiTextField: UITextField!
    @IBOutlet private weak var verfiTextFieldWidth: NSLayoutConstraint!
    
    var stateChanged: ((_ isEnable: Bool) -> ())?
    var accountText: String?
    var passwordText: String?
    var type = LoginType.verficationCode {
        didSet {
            switch type {
            case .password:
                passwordLabel.text = "密   码"
                verfiTextField.placeholder = "输入密码"
                verfiTextField.isSecureTextEntry = true
                verfiButton.isHidden = true
                verfiTextFieldWidth.constant = 0
            case .verficationCode:
                verfiTextFieldWidth.constant = 114
                passwordLabel.text = "验 证 码"
                verfiTextField.placeholder = "输入验证码"
            }
            layoutIfNeeded()
        }
    }
    public func reset() {
        verfiTextField.text = nil
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXib()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXib()
    }
    
    public func initFromXib() {
        let nib = UINib(nibName: "ZJLoginView", bundle: nil)
        loginView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        loginView.frame = bounds
        accountTextField.addTarget(self, action: #selector(textFieldTextDidChange),
                                                 for: UIControl.Event.editingChanged)
        verfiTextField.addTarget(self, action: #selector(textFieldTextDidChange),
                                   for: UIControl.Event.editingChanged)
        addSubview(loginView)
    }
    
    @IBAction func getVerfiCode(_ sender: VerficationButton) {
        guard let num = accountText else {
            print("手机号码不能为空")
            return
        }
        if !num.isTelNumber() {
            print("不是手机号码")
            return
        }
        let urlString = "http://106.52.2.54:8080/SMIMQ/" + "mankeep/checkphone"
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: ["tgusetaccount":num,"checktype":"2"], successBlock: { (result) in
            print(result)
        }) { (error) in
            print(error)
        }
        sender.isEnabled.toggle()
    }
}

extension ZJLoginView: UITextFieldDelegate {
    @objc private func textFieldTextDidChange(textField: UITextField) {
        accountText = accountTextField.text
        passwordText = verfiTextField.text
        
        guard let text = textField.text else {
            return
        }
        
        if let account = accountTextField.text, let pwd = verfiTextField.text {
            if account.count > 0 && pwd.count > 0 {
                stateChanged?(true)
            } else {
                stateChanged?(false)
            }
        }
//        let str = disableEmoji(text: text)
//        //保存按钮的是否可用
//        let allSpace = str.trimmingCharacters(in: NSCharacterSet.whitespaces)
//
//        //markedTextRange 表示联想，此时不做处理
//        if textField.markedTextRange == nil {
//            //            if str.count > textField.limitCount {
//            //                textField.text = str.substring(to: textField.limitCount)
//            //            } else {
//            //                textField.text = str
//            //            }
//            return
//        }
    }
    
    
}
