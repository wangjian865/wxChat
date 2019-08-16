//
//  RegisterViewController.swift
//  login
//
//  Created by gwj on 2019/6/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class RegisterViewController: InputViewController,UITextViewDelegate {
    var agreementLabel = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .register
//        agreementLabel.text = "继续即表示您同意《竹简服务协议》和《隐私策略》"
//        agreementLabel.textColor = UIColor.gray
//        agreementLabel.font = UIFont.systemFont(ofSize: 13)
        
        let text = NSMutableAttributedString(string: "继续即表示您同意")
        text.addAttribute(NSAttributedString.Key.font,
                          value: UIFont.systemFont(ofSize: 13),
                          range: NSRange(location: 0, length: text.length))
        
        let serviceText = NSMutableAttributedString(string: "《竹简服务协议》")
        serviceText.addAttribute(NSAttributedString.Key.font,
                                      value: UIFont.systemFont(ofSize: 13),
                                      range: NSRange(location: 0, length: serviceText.length))
        
        serviceText.addAttribute(NSAttributedString.Key.link,
                                 value: "http://service",
                                      range: NSRange(location: 0, length: serviceText.length))
        let privateText = NSMutableAttributedString(string: "《隐私策略》")
        privateText.addAttribute(NSAttributedString.Key.font,
                                      value: UIFont.systemFont(ofSize: 13),
                                      range: NSRange(location: 0, length: privateText.length))
        
        privateText.addAttribute(NSAttributedString.Key.link,
                                 value: "http://private",
                                      range: NSRange(location: 0, length: privateText.length))
        // Adding it all together
        text.append(serviceText)
        text.append(privateText)
        agreementLabel.attributedText = text
        agreementLabel.textAlignment = .center
        agreementLabel.delegate = self
        agreementLabel.isEditable = false
        view.addSubview(agreementLabel)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        agreementLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(icon.snp_bottom).offset(15)
            make.height.equalTo(30)
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let operation = URL.scheme, operation.elementsEqual("http"){
            let vc = WXWebViewController.init()
            if operation == "service"{
                vc.title = "竹简服务协议"
            }else{
                vc.title = "隐私策略"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }

        return false
    }
    //点击注册
    override func clickButton() {
        let urlString = WXApiManager.getRequestUrl("manKeep/register")
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: ["tgusetaccount":account,"tgusetpassword":password,"code":code], successBlock: { (result) in
            let dic = result as! [String:Any]
            let code = dic["code"] as! Int
            if code == 200{
                //成功
                //showalert
                self.navigationController?.popViewController(animated: true)
            }else{
                let msg = dic["msg"] as! String
                MBProgressHUD.showError(msg)
            }
            print(result)
        }) { (error) in
            print(error)
        }
        
    }
    override func getCode(num: String) {
        let urlString = WXApiManager.getRequestUrl("manKeep/checkPhone")
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: ["tgusetaccount":num,"checktype":"1"], successBlock: { (result) in
            print(result)
            let dic = result as! [String:Any]
            let code = dic["code"] as! Int
            if code == 200{
                //成功
                //showalert
//                self.navigationController?.popViewController(animated: true)
            }else{
                let msg = dic["msg"] as! String
                MBProgressHUD.showError(msg)
            }
        }) { (error) in
            print(error)
        }
    }
}
