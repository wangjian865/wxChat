//
//  ViewController.swift
//  login
//
//  Created by gwj on 2019/6/17.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class LoinController: UIViewController {
  
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verficationButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        defaultSetting()
    }
    
    private func defaultSetting() {
        accountTextField.addTarget(self,action: #selector(textFieldTextDidChange),
                                   for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldTextDidChange),
                                    for: UIControl.Event.editingChanged)
        
    }
    
    @objc private func textFieldTextDidChange(textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if let account = accountTextField.text, let pwd = passwordTextField.text {
            if account.count > 0 && pwd.count > 0 {
                loginButton.isEnabled = true
                loginButton.backgroundColor = .blue
            } else {
                loginButton.isEnabled = true
                loginButton.backgroundColor = .gray
            }
            
        }

        let str = disableEmoji(text: text)
        //保存按钮的是否可用
        let allSpace = str.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        if str.count > 0, allSpace.count > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        //markedTextRange 表示联想，此时不做处理
        if textField.markedTextRange == nil {
//            if str.count > textField.limitCount {
//                textField.text = str.substring(to: textField.limitCount)
//            } else {
//                textField.text = str
//            }
            return
        }
    }
    
    private func disableEmoji(text: String) -> String {
        let regex = try!NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]",
                                                 options: .caseInsensitive)
        let modifiedString = regex.stringByReplacingMatches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: text.count), withTemplate: "")
        return modifiedString
    }
    
    @IBAction func getVerficationCode(_ sender: UIButton) {
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
    }
    
    @IBAction func getPassword(_ sender: UIButton) {
        
    }
    
    @IBAction func loginByPassword(_ sender: UIButton) {
        
    }
    
}

//extension LoinController: UITextFieldDelegate {
//
//}

class AiLabelTextField: UITextField {
    //最小输入字符数
    var limitCount = 6
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        super.rightViewRect(forBounds: bounds)
        return CGRect(x: bounds.size.width - 40, y: bounds.midY - 12, width: 24, height: 24)
    }
    
    deinit {
        print("AiLabelTextField dealloc")
    }
}
